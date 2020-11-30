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

echo "*** bjam ${MAKE_OPTIONS} install"

./bjam  ${MAKE_OPTIONS} install

if [ $? -ne 0 ]
then
    echo "ERROR on bjam install"
    exit 3
fi

echo
echo "########## END"
