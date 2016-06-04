from libcpp cimport bool

cdef extern from "uci.h":
	cdef struct uci_context:
		pass

	cdef struct uci_package:
		pass

	cdef struct uci_section:
		pass

	uci_context* uci_alloc_context()
	void uci_free_context(uci_context* ctx)

	int uci_set_confdir(uci_context* ctx, const char* dir)

	int uci_load(uci_context* ctx, const char* config_name, uci_package** package)
	int uci_unload(uci_context* ctx, uci_package* package)

	uci_package* uci_lookup_package(uci_context* ctx, const char* package_name)
	uci_section* uci_lookup_section(uci_context* ctx, uci_package* package, const char* section_name)
	const char* uci_lookup_option_string(uci_context* ctx, uci_section* section, const char* option_name)
