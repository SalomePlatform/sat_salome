#!/bin/bash

echo "##########################################################################"
echo "mmg " $VERSION
echo "##########################################################################"

echo "Installing binary version"
if [ ! -d $PRODUCT_INSTALL ]; then
    mkdir -p $PRODUCT_INSTALL
fi
ls $SOURCE_DIR -ltr
mkdir -p $PRODUCT_INSTALL/bin
cp -r $SOURCE_DIR/* $PRODUCT_INSTALL/bin

for f in $(ls $PRODUCT_INSTALL/bin); do
    chmod 755 $PRODUCT_INSTALL/bin/$f
done

echo
echo "########## END"

