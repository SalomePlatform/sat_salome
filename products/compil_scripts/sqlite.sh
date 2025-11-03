#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

cd $BUILD_DIR

export TCLLIBDIR="$PRODUCT_INSTALL/lib"
BUILD_TYPE=
if [ -n "$SAT_DEBUG" ]; then
    BUILD_TYPE="--enable-debug  CFLAGS=\'-O0 -g\'"
fi

CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" -prefix=$PRODUCT_INSTALL"
CONFIGURE_OPTIONS+=" --enable-all"
CONFIGURE_OPTIONS+=" --enable-rtree"
CONFIGURE_OPTIONS+=" $BUILD_TYPE"

echo
echo "*** configure ${CONFIGURE_OPTIONS}"
$SOURCE_DIR/configure ${CONFIGURE_OPTIONS}
if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make $MAKE_OPTIONS"
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 4
fi

