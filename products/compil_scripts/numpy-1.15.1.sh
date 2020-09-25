#!/bin/bash

echo "##########################################################################"
echo "numpy" $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL

cd $SOURCE_DIR

## editer customize.py Pour LApack : using Atlas, Pour Blas : Using gsl
# OP 29/03/2018 We create a build configuration file to set
#               information about lapack preprequisite
echo "#" > site.cfg
echo "# Build configuration for numpy" >> site.cfg
echo "#" >> site.cfg
echo >> site.cfg
echo "# Section ALL to set global information for lapack dependency" >> site.cfg
echo "[ALL]" >> site.cfg
echo "libraries = lapack,blas,cblas,lapacke,tmglib" >> site.cfg
echo "library_dirs = \$\{LAPACKHOME\}/lib" >> site.cfg
#echo "runtime_library_dirs = ${LAPACKHOME}/lib" >> site.cfg
echo "include_dirs = \$\{LAPACKHOME\}/include" >> site.cfg
#echo "extra_link_args = -lcblas" >> site.cfg
echo >> site.cfg


NUMPY_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${NUMPY_INSTALL}
PYTHONPATH=${NUMPY_INSTALL}:${PYTHONPATH}

echo
echo "*** setup.py install"
python setup.py install --prefix=${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on setup install"
    rm -f site.cfg
    exit 2
fi

rm -f site.cfg

echo
echo "########## END"

