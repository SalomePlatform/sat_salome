#!/bin/bash

echo "##########################################################################"
echo "tcltk" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR/tcl ; rm -rf $BUILD_DIR/tcl
mkdir $BUILD_DIR/tcl ; mkdir $BUILD_DIR/tk
cd $BUILD_DIR

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" --prefix=$PRODUCT_INSTALL"
CONFIGURE_OPTIONS+=" --enable-shared"
CONFIGURE_OPTIONS+=" --enable-threads"

opts=()
if [ "$DIST_NAME" = "macOS" ]; then
    export CFLAGS="-arch arm64 -isysroot $(xcrun --show-sdk-path) \
        -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
    export LDFLAGS="-arch arm64 -isysroot $(xcrun --show-sdk-path)"
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
fi

error_recovery() {
    if [ $? -ne 0 ]; then
        echo "ERROR on $1"
        exit $2
    fi
}

build() {
    cd $BUILD_DIR/$1

    echo
    echo "*** $1 configure $CONFIGURE_OPTIONS"
    $SOURCE_DIR/$1/unix/configure $CONFIGURE_OPTIONS  "${opts[@]}"
    error_recovery "$1 configure" 2

    echo
    echo "*** $1 make"
    make $MAKE_OPTIONS
    error_recovery "$1 make" 3

    echo
    echo "*** $1 make install"
    make install
    error_recovery "$1 make install" 3
}

build tcl

CONFIGURE_OPTIONS+=" --with-tcl=$PRODUCT_INSTALL/lib"
CONFIGURE_OPTIONS+=" --with-tclinclude=$PRODUCT_INSTALL/include"
CONFIGURE_OPTIONS+=" --enable-aqua"

build tk

echo
echo "########## END"
