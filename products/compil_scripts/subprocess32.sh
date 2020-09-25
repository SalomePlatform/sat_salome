#!/bin/bash

echo "##########################################################################"
echo "subprocess32" $VERSION
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

SUBPROCESS_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${SUBPROCESS_INSTALL}
export PYTHONPATH=${SUBPROCESS_INSTALL}:${PYTHONPATH}
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
