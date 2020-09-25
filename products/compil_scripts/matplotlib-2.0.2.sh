#!/bin/bash

echo "##########################################################################"
echo "matplotlib" $VERSION
echo "##########################################################################"

rm -rf $PRODUCT_INSTALL
mkdir -p $PRODUCT_INSTALL
echo
echo "*** setup.py"

cp -r $SOURCE_DIR/* .

# Making a directory that will be used in install
BUILD_DIR=`pwd`
cd $PRODUCT_INSTALL
mkdir -p lib/python${PYTHON_VERSION}/site-packages
cd $BUILD_DIR
# Hack PYTHONPATH in order to make 'setup.py install' believe that PRODUCT_INSTALL is in PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH


echo "*** setup.py BUILD"

python setup.py build

echo "*** setup.py INSTALL"

python setup.py install --prefix=${PRODUCT_INSTALL}

if [ $? -ne 0 ]
then
    echo "ERROR on setup"
    exit 3
fi

echo
echo "########## END"

