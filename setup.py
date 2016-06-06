from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize

setup(
    name="pyuci",
    description="OpenWRT Universal Configuration Interface for Python",
    author="Laurence de Bruxelles",
    author_email="lfdebrux@gmail.com",
    test_suite="test",
    ext_modules=cythonize([
        Extension("uci", ["uci.pyx"],
                  libraries=["uci"])])
)
