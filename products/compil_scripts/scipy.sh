#!/bin/bash

echo "##########################################################################"
echo "scipy" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

echo
echo "*** build"
echo ${PYTHONPATH}
python setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

SCIPY_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${SCIPY_INSTALL}
PYTHONPATH=${SCIPY_INSTALL}:${PYTHONPATH}
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

