# (C) 2016 Laurence de Bruxelles <lfdebrux@gmail.com>
#
# SPDX-License-Identifier:    BSD-3-Clause

from libcpp cimport bool

cdef extern from "uci.h":

	# uci linked list
	#
	cdef struct uci_list:
		uci_list* next

	cdef struct uci_element:
		uci_list list
		char* name

	uci_element* list_to_element(uci_list*)
	uci_option* uci_to_option(uci_element*)

	# uci tree element types
	#
	cdef struct uci_context:
		pass

	cdef struct uci_package:
		uci_list sections

	cdef struct uci_section:
		uci_list options

	cdef enum uci_option_type:
		UCI_TYPE_STRING = 0
		UCI_TYPE_LIST = 1

	cdef union uci_option_union:
		uci_list list
		char* string

	cdef struct uci_option:
		uci_option_type type
		uci_option_union v

	uci_context* uci_alloc_context()
	void uci_free_context(uci_context* ctx)

	int uci_set_confdir(uci_context* ctx, const char* dir)

	int uci_list_configs(uci_context* ctx, char*** list)

	int uci_load(uci_context* ctx, const char* config_name, uci_package** package)
	int uci_unload(uci_context* ctx, uci_package* package)

	uci_package* uci_lookup_package(uci_context* ctx, const char* package_name)
	uci_section* uci_lookup_section(uci_context* ctx, uci_package* package, const char* section_name)
	uci_option* uci_lookup_option(uci_context* ctx, uci_section* section, const char* option_name)
