#!/bin/bash

echo "###############################################"
echo "rapidjson" $VERSION
echo "###############################################"

mkdir -p $PRODUCT_INSTALL
cp -r $SOURCE_DIR/include $PRODUCT_INSTALL

echo
echo "########## END"

