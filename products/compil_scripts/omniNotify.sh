#!/bin/bash

echo "##########################################################################"
echo "omniNotify" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* . 

echo
echo "*** configure"
./configure --prefix=${OMNIORB_ROOT_DIR} PYTHON=${PYTHON_ROOT_DIR}/bin/python
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 3
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

mkdir -p $PRODUCT_INSTALL
echo "omniNotify is installed into omni dir ${OMNIORB_ROOT_DIR}" > $PRODUCT_INSTALL/README

echo
echo "########## END"

