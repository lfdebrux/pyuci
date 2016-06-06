# cython: c_string_type=str, c_string_encoding=ascii
# ^^ implicit string decoding

cimport cuci

import os.path

from ConfigParser import Error, \
                         NoSectionError, \
                         NoOptionError, \
                         ParsingError


class NoConfigError(Error):
    """A matching config file was not found"""

    def __init__(self, config):
        Error.__init__(self, 'No config: %r' % (config,))
        self.config = config
        self.args = (config,)


cdef int _next_element(cuci.uci_list* l, cuci.uci_element** e):
    '''
    uci_list* l is head of list

    copies pointer to next element into e,
    until the list loops back round to the head
    '''
    if e[0] is NULL:
        e[0] = cuci.list_to_element(l.next)
        return 1
    else:
        e[0] = cuci.list_to_element(e[0].list.next)

    if &e[0].list is not l:
        return 1
    else:
        return 0


cdef class UCI:

    cdef cuci.uci_context* _ctx

    def __cinit__(self):
        self._ctx = cuci.uci_alloc_context()
        if self._ctx is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._ctx is not NULL:
            cuci.uci_free_context(self._ctx)

    def __init__(self, confdir=None):
        if confdir is not None:
            cuci.uci_set_confdir(self._ctx, confdir)

    cdef cuci.uci_package* _get_package(self, config) except NULL:
        # have we loaded this package before?
        cdef cuci.uci_package* p = cuci.uci_lookup_package(self._ctx, config)
        if p is NULL:
            # try loading the package
            cuci.uci_load(self._ctx, config, &p)
        if p is NULL:
            raise NoConfigError(config)
        return p

    cdef cuci.uci_section* _get_section(self, config, section) except NULL:
        cdef cuci.uci_package* p = self._get_package(config)

        # look up the section
        cdef cuci.uci_section* s = cuci.uci_lookup_section(self._ctx, p, section)
        if s is NULL:
            raise NoSectionError(section)

        return s

    cdef cuci.uci_option* _get_option(self, config, section, option) except NULL:
        cdef cuci.uci_section *s = self._get_section(config, section)

        # look up the option
        cdef cuci.uci_option* o = cuci.uci_lookup_option(self._ctx, s, option)
        if o is NULL:
            raise NoOptionError(option, section)

        return o

    cdef object _get_option_value(self, cuci.uci_option* o):
        cdef object option_value
        cdef cuci.uci_element* e = NULL # cython complains if we don't put this here
        if o.type == cuci.UCI_TYPE_STRING:
            option_value = o.v.string
            return option_value
        elif o.type == cuci.UCI_TYPE_LIST:
            option_value = []
            while _next_element(&o.v.list, &e):
                option_value.append(e.name)
            return option_value
        else:
            # parsing error?
            raise RuntimeError('option has invalid UCI_TYPE')

    def options(self, config, section):
        '''list of options in section'''

        cdef cuci.uci_section* s = self._get_section(config, section)

        cdef cuci.uci_element* e = NULL
        cdef object options = []
        while _next_element(&s.options, &e):
            options.append(e.name)

        return options

    def has_option(self, config, section, option):
        '''indicates whether the section has the named option'''

        try:
            self._get_option(config, section, option)
        except NoOptionError:
            return False
        else:
            return True

    def items(self, config, section):
        '''return a list of (name, value) pairs for each option in the section'''

        cdef cuci.uci_section* s = self._get_section(config, section)

        cdef object items = []
        cdef cuci.uci_element* e = NULL
        cdef cuci.uci_option* o = NULL
        while _next_element(&s.options, &e):
            o = cuci.uci_to_option(e)
            items.append((e.name, self._get_option_value(o)))

        return items

    def get(self, config, section, option):
        '''get value of option'''

        # look up the option
        cdef cuci.uci_option* o = self._get_option(config, section, option)
        return self._get_option_value(o)
