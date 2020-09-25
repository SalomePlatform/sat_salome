#!/bin/bash

echo "##########################################################################"
echo "functools32" $VERSION
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

FUNCTOOLS_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${FUNCTOOLS_INSTALL}
export PYTHONPATH=${FUNCTOOLS_INSTALL}:${PYTHONPATH}
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
