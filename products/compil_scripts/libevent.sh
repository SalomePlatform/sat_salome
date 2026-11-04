#!/bin/bash

echo "##########################################################################"
echo "Libevent" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

# -p option ensures that the date remain the same.
cp -p -r $SOURCE_DIR/* .

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

if [ -f autogen.pl ] && [ ! -f configure ]; then
    echo
    echo "*** autogen.pl"
    chmod +x autogen.pl
    ./autogen.pl
    if [ $? -ne 0 ]; then
        echo "ERROR on autogen.pl"
        exit 1
    fi
fi

opts=()

if [ "$DIST_NAME" == "macOS" ]; then
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
    export PKG_CONFIG_PATH="$OPENSSL_ROOT_DIR/lib/pkgconfig"
    export PKG_CONFIG_LIBDIR="$OPENSSL_ROOT_DIR/lib/pkgconfig:$SYSROOT/usr/lib/pkgconfig"
    export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
    export CPPFLAGS="-I$OPENSSL_ROOT_DIR/include"
    export LDFLAGS="-L$OPENSSL_ROOT_DIR/lib -Wl,-rpath,$OPENSSL_ROOT_DIR/lib"
fi

CONFIG_OPTIONS=
CONFIG_OPTIONS+=" --prefix=$PRODUCT_INSTALL"

if [ -n ${SAT_DEBUG} ]; then
    CONFIG_OPTIONS+=" --enable-debug ac_cv_func_pipe2=no"
fi
echo
echo "*** configure"
$BUILD_DIR/configure $CONFIG_OPTIONS "${opts[@]}"
if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
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

echo
echo "########## END"

