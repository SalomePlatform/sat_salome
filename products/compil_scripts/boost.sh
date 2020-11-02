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

echo "*** bjam install"

./bjam -j4 install

if [ $? -ne 0 ]
then
    echo "ERROR on bjam install"
    exit 3
fi

echo
echo "########## END"
