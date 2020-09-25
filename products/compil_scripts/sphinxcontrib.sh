#!/bin/bash

echo "##########################################################################"
echo "sphinxcontrib" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

echo
echo "*** build"
python setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

SPHINXCONTRIB_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${SPHINXCONTRIB_INSTALL}
export PYTHONPATH=${SPHINXCONTRIB_INSTALL}:${PYTHONPATH}
echo
echo "*** install"
python setup.py install --prefix=${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

echo
echo "########## END"
