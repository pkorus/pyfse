from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

example_extension = Extension(
    name="pyfse",
    sources=["pyfse.pyx"],
    libraries=["fse"],
    library_dirs=["FiniteStateEntropy/lib"],
    include_dirs=["FiniteStateEntropy/lib"]
)
setup(
    name="pyfse",
    ext_modules=cythonize([example_extension])
)
