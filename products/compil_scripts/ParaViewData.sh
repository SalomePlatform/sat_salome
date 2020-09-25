#!/bin/bash

echo "##########################################################################"
echo "ParaViewData" $VERSION
echo "##########################################################################"



mkdir -p $PRODUCT_INSTALL
cp -a $SOURCE_DIR/* $PRODUCT_INSTALL

echo
echo "########## END"

