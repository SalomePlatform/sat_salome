#!/bin/bash

echo "##########################################################################"
echo "EIGEN" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

echo
echo "*** mkdir" $PRODUCT_INSTALL
mkdir -p $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on mkdir"
    exit 1
fi

echo
echo "*** cp -r * " $PRODUCT_INSTALL
cp -r * $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on cp"
    exit 2
fi

echo
echo "########## END"
