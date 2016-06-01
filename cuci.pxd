from libcpp cimport bool

cdef extern from "uci.h":
	cdef struct uci_context:
		pass
	cdef struct uci_package:
		pass
	cdef struct uci_ptr:
		pass

	uci_context* uci_alloc_context()
	void uci_free_context(uci_context* ctx)

	int uci_load(uci_context* ctx, const char* config_name, uci_package** package)
	int uci_unload(uci_context *ctx, uci_package* package)

	int uci_lookup_ptr(uci_context* ctx, uci_ptr* ptr, char *str query, bool extended)
