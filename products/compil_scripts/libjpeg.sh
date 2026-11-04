#!/bin/bash

echo "##########################################################################"
echo "libjpeg" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd  $BUILD_DIR

CONFIGURE_OPTIONS=" --prefix=$PRODUCT_INSTALL"

opts=()
if [ "$DIST_NAME" = "macOS" ]; then
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
fi

echo
echo "*** configure $CONFIGURE_OPTIONS ${opts[@]}"
$SOURCE_DIR/configure $CONFIGURE_OPTIONS "${opts[@]}"
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo "*** make ${MAKE_OPTIONS}"
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "########## END"

