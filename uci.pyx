cimport cuci

cdef class Config:
    cdef cuci.uci_context* _ctx
    def __cinit__(self):
        self._ctx = cuci.uci_alloc_context()
        if self._ctx is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._ctx is not NULL:
            cuci.uci_free_context(self._ctx)
