from distutils.core import setup
from distutils.extensions import Extension
from Cython.build import cythonize

setup(
    ext_modules=cythonize([
        Extension("uci", ["uci.pyx"],
                  libraries=["uci"])])
)
