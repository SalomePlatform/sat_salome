#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

if [ -f "$SOURCE_DIR/bin/ninja" ]
then
    echo "INFO: about to copy the ninja binary utility to the installation folder: $PRODUCT_INSTALL/bin"
    mkdir -p $PRODUCT_INSTALL/bin || { echo "ERROR: fail to create $PRODUCT_INSTALL/bin"; exit 1; }
    cp  $SOURCE_DIR/bin/ninja $PRODUCT_INSTALL/bin || { echo "ERROR: fail to copy binary"; exit 1; }
    chmod +x $PRODUCT_INSTALL/bin/ninja
else
    echo "FATAL: NOT IMPLEMENTED"
    exit 1
fi

echo
echo "########## END"
