# cython: c_string_type=str, c_string_encoding=ascii
# ^^ implicit string decoding

cimport cuci

from ConfigParser import Error, \
                         NoSectionError, \
                         NoOptionError


class NoConfigError(Error):
    """A matching config file was not found"""

    def __init__(self, config):
        Error.__init__(self, 'No config: %r' % (config,))
        self.config = config
        self.args = (config,)


cdef class Config:

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

    def get(self, config, section, option):
        '''look up option'''

        # have we loaded this package before?
        cdef cuci.uci_package* p = cuci.uci_lookup_package(self._ctx, config)
        if p is NULL:
            # try loading the package
            cuci.uci_load(self._ctx, config, &p)
        if p is NULL:
            raise NoConfigError(config)

        # look up the section
        cdef cuci.uci_section* s = cuci.uci_lookup_section(self._ctx, p, section)
        if s is NULL:
            raise NoSectionError(section)

        # look up the option
        cdef char* c_option_value = cuci.uci_lookup_option_string(self._ctx, s, option)
        if c_option_value is NULL:
            raise NoOptionError(option, section)

        cdef object option_value = c_option_value

        return option_value
