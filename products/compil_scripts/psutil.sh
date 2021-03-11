#!/bin/bash

echo "##########################################################################"
echo "psutil" $VERSION
echo "##########################################################################"



echo  "*** build in SOURCE directory"
cd $SOURCE_DIR

# we don't install in python directory -> modify environment as described in INSTALL file
mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION:0:3}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION:0:3}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on build/install"
    exit 3
fi

echo
echo "######psutil END"
