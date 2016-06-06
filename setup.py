# (C) 2016 Laurence de Bruxelles <lfdebrux@gmail.com>
#
# SPDX-License-Identifier:    BSD-3-Clause

from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize

setup(
    name="pyuci",
    version="0.1.0.dev1",
    description="OpenWRT Universal Configuration Interface for Python",
    author="Laurence de Bruxelles",
    author_email="lfdebrux@gmail.com",
    url="https://github.com/lfdebrux/pyuci",
    test_suite="test",
    ext_modules=cythonize([
        Extension("uci", ["uci.pyx"],
                  libraries=["uci"])])
)
