#!/bin/bash

echo "##########################################################################"
echo "cairo" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd  $BUILD_DIR

export PKG_CONFIG_PATH="$LIBPNG_ROOT_DIR/lib/pkgconfig:$PIXMAN_ROOT_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

pkg-config --libs libpng
grep -E '^(prefix|libdir)|^Libs' "$LIBPNG_ROOT_DIR"/lib/pkgconfig/libpng*.pc
ls "$LIBPNG_ROOT_DIR"/lib/ | grep png

declare -a OPTS

OPTS+=("--prefix=$PRODUCT_INSTALL")
OPTS+=("--enable-png=yes")
OPTS+=("pixman_CFLAGS=-I${PIXMAN_ROOT_DIR}/include/pixman-1")
OPTS+=("pixman_LIBS=-L${PIXMAN_ROOT_DIR}/lib -lpixman-1")
OPTS+=("--enable-ft=yes")
OPTS+=("--enable-fc=no")

opts_mac=()
if [ "$DIST_NAME" = "macOS" ]; then
    eval "opts_mac=($SAT_CONFIGURE_OPTIONS)"
fi

echo
echo "*** configure"
"$SOURCE_DIR/configure" "${OPTS[@]}" "${opts_mac[@]}"


if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

#Skip test
#sed -i '' -E '/^SUBDIRS =/ s/ (boilerplate|test|perf)//g' Makefile

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
