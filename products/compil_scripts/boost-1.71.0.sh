#!/bin/bash

echo "##########################################################################"
echo "BOOST" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

echo
echo "*** bootstrap.sh"
./bootstrap.sh --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on bootstrap"
    exit 1
fi

echo "*** b2 ${MAKE_OPTIONS} install"

./b2  ${MAKE_OPTIONS} install

if [ $? -ne 0 ]
then
    echo "ERROR on b2 install"
    exit 3
fi

echo
echo "########## END"
