#!/bin/bash

echo "##########################################################################"
echo "tcl" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

CONFIGURE_OPTIONS="--prefix=${PRODUCT_INSTALL}"
CONFIGURE_OPTIONS+=" --enable-shared"
CONFIGURE_OPTIONS+=" --enable-threads"

if [ $DIST_NAME = "macOS" ]; then
    export CFLAGS="-arch arm64 -isysroot $(xcrun --show-sdk-path) \
        -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
    export LDFLAGS="-arch arm64 -isysroot $(xcrun --show-sdk-path)"
    export ac_cv_func_strtod=yes
    CONFIGURE_OPTIONS+=" --enable-64bit=max"
fi

echo
echo "*** configure $CONFIGURE_OPTIONS"
$SOURCE_DIR/unix/configure $CONFIGURE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

if [ $DIST_NAME = "macOS" ]; then
 sed -i "" -e "s/strtod.o fixstrtod.o//g" Makefile
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

