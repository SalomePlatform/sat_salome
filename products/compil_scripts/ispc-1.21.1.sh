#!/bin/bash

echo "##########################################################################"
echo "ispc" $VERSION
echo "##########################################################################"

if [ -d "$SOURCE_DIR/bin" ]; then
    echo "INFO: about to copy the ispc binary utility to the installation folder: $PRODUCT_INSTALL/bin"
    mkdir -p "$PRODUCT_INSTALL/bin"
    cp -r "$SOURCE_DIR/bin/"* "$PRODUCT_INSTALL/bin"
    chmod -R +x $PRODUCT_INSTALL/bin/*
else
    echo "FATAL: NOT IMPLEMENTED"
    exit 1
fi

if [ -d "$SOURCE_DIR/lib64" ]; then
    echo "INFO: about to copy the ispc libraries to the installation folder: $PRODUCT_INSTALL/lib"
    mkdir -p "$PRODUCT_INSTALL/lib"
    cp -r "$SOURCE_DIR/lib64/"* "$PRODUCT_INSTALL/lib"
else
    echo "FATAL: libraries not found"
    exit 2
fi

if [ -d "$SOURCE_DIR/include" ]; then
    echo "INFO: about to cpoy the include files to the installation folder: $PRODUCT_INSTALL/include"
    mkdir -p "$PRODUCT_INSTALL/include"
    cp -r "$SOURCE_DIR/include/"* "$PRODUCT_INSTALL/include"
else
    echo "FATAL: include files not found"
    exit 3
fi

echo
echo "########## END"
