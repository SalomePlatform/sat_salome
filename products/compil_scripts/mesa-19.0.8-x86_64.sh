#!/bin/bash

echo "##########################################################################"
echo "mesa" $VERSION
echo "##########################################################################"

echo "Installing binary version"
if [ -d $PRODUCT_INSTALL ]; then
    :
else
    mkdir -p $PRODUCT_INSTALL
fi
cp -r $SOURCE_DIR/* $PRODUCT_INSTALL

echo
echo "########## END"

