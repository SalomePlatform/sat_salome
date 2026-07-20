#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "root" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

if [ ! -d $PRODUCT_INSTALL ]; then
    mkdir -p $PRODUCT_INSTALL
fi

# Copy the binary package from the source directory to the installation directory
cp -r $SOURCE_DIR/* $PRODUCT_INSTALL
if [ $? -ne 0 ]; then
    echo "ERROR: could not copy ROOT files from $SOURCE_DIR to $PRODUCT_INSTALL"
    exit 1
fi

echo
echo "########## END"
