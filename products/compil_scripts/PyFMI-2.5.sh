#!/bin/bash

#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "PyFMI " $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"


cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

rm -f $BUILD_DIR/src/pyfmi/*.c
mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION:0:3}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION:0:3}/site-packages:$PYTHONPATH

echo
echo "*** build with $PYTHONBIN"
$PYTHONBIN setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

echo
echo "*** install with $PYTHONBIN"
$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL --fmil-home=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

echo
echo "########## END"
