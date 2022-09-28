#!/bin/bash

echo "##########################################################################"
echo "PyQt" $VERSION
echo "##########################################################################"

python_name=python$PYTHON_VERSION

cd $SOURCE_DIR

if [ "${SAT_Python_IS_NATIVE}" == "1" ]
then
    # if not set, will try to install in system path...
    mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    export PATH=$(pwd)/bin:$PATH
    export PYTHONPATH=$(pwd):$PYTHONPATH
    export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
fi

echo
echo "*** configure.py --confirm-license --no-designer-plugin --verbose --bindir=${PRODUCT_INSTALL}/bin --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages --stubsdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages --sipdir=${SIP_ROOT_DIR} --disable=QtNetwork --disable=QtWebSockets"
$PYTHONBIN ./configure.py --confirm-license --no-designer-plugin --verbose \
    --bindir=${PRODUCT_INSTALL}/bin \
    --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages \
    --stubsdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages \
    --sipdir=${SIP_ROOT_DIR} \
    --disable=QtNetwork --disable=QtWebSockets 2>&1

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]
then
    echo "ERROR on make clean"
    exit 5
fi

# Issue with GUI - TO BE FIXED
if [ -n "$SIP_ROOT_DIR" ]
then
    mkdir -p $PRODUCT_INSTALL/sip
    cp -r $SIP_ROOT_DIR/* $PRODUCT_INSTALL/sip
else
    echo "FATAL: Please set SIP_ROOT_DIR environment variable"
    exit 6
fi

echo
echo "########## END"

exit 0

