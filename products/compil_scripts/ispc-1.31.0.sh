#!/bin/bash

echo "##########################################################################"
echo "ispc" $VERSION
echo "##########################################################################"

if [ -f "$SOURCE_DIR/bin/ispc" ]
then
    echo "INFO: about to copy the ispc binary utility to the installation folder: $PRODUCT_INSTALL/bin"
    mkdir -p $PRODUCT_INSTALL/bin
    cp  $SOURCE_DIR/bin/ispc $PRODUCT_INSTALL/bin
    chmod +x $PRODUCT_INSTALL/bin/ispc
else
    echo "FATAL: NOT IMPLEMENTED"
    exit 1
fi

if [ -d "$SOURCE_DIR/lib" ]
then
    echo "INFO: about to copy the ispc library utility to the installation folder: $PRODUCT_INSTALL/lib"
    cp  -r $SOURCE_DIR/lib $PRODUCT_INSTALL/lib
else
    echo "FATAL: NOT IMPLEMENTED"
    exit 1
fi

if [ -d "$SOURCE_DIR/include" ]
then
    echo "INFO: about to copy the ispc include folder to the installation folder: $PRODUCT_INSTALL/include"
    cp  -r $SOURCE_DIR/include $PRODUCT_INSTALL/include
else
    echo "FATAL: NOT IMPLEMENTED"
    exit 1
fi

echo
echo "########## END"
