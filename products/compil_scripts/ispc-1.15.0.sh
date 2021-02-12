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

echo
echo "########## END"
