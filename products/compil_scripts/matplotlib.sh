#!/bin/bash

echo "##########################################################################"
echo "matplotlib" $VERSION
echo "##########################################################################"



echo  "*** build in SOURCE directory"
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

# we don't install in python directory -> modify environment as described in INSTALL file
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
$PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on build/install"
    exit 3
fi

echo
echo "########## END"
