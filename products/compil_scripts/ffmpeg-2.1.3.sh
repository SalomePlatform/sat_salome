#!/bin/bash

echo "##########################################################################"
echo "ffmpeg" $VERSION
echo "##########################################################################"

mkdir -p $PRODUCT_INSTALL

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

cp -r $SOURCE_DIR/* . 

CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" --prefix=${PRODUCT_INSTALL}"
CONFIGURE_OPTIONS+=" --disable-yasm"
CONFIGURE_OPTIONS+=" --disable-doc"
CONFIGURE_OPTIONS+=" --enable-shared"

echo
echo "*** configure $CONFIGURE_OPTIONS"
$BUILD_DIR/configure $CONFIGURE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"
