#!/bin/bash

echo "##########################################################################"
echo "OPENSSL" $VERSION
echo "##########################################################################"


CONFIGURE_OPTIONS=" --prefix=$PRODUCT_INSTALL"
if [ $DIST_NAME = "macOS" ] && [ $RPATH_ENABLE -ne 0 ]; then
    CONFIGURE_OPTIONS+=" -Wl,-rpath,@loader_path/../lib -Wl,-rpath,@loader_path"
fi

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

echo **** $SOURCE_DIR/Configure darwin64-arm64-cc $CONFIGURE_OPTIONS
$SOURCE_DIR/Configure darwin64-arm64-cc $CONFIGURE_OPTIONS
if [ $? -ne 0 ]; then
    echo "Error could not configure openssl"
    exit 1
fi

make
if [ $? -ne 0 ]; then 
    echo "Error could not build openssl"
    exit 2
fi

make install
if [ $? -ne 0 ]; then 
    echo "Error could not install openssl"
    exit 3
fi

echo
echo "########## END"
