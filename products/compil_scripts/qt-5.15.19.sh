#!/bin/bash

echo "##########################################################################"
echo "Qt" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
case $LINUX_DISTRIBUTION in
    FD32|DB11)
        export  QMAKE_CXXFLAGS="-std=c++11"
        ;;
    *)
        ;;
esac

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

if [ -n "$SAT_DEBUG" ]; then
    BUILD_TYPE="-debug"
else
    BUILD_TYPE="-release"
fi

# clean build directory
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR && cd $BUILD_DIR
echo $PRODUCT_INSTALL
CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" -prefix $PRODUCT_INSTALL"
CONFIGURE_OPTIONS+=" $BUILD_TYPE"
CONFIGURE_OPTIONS+=" -opensource"
CONFIGURE_OPTIONS+=" -nomake tests"
CONFIGURE_OPTIONS+=" -nomake examples"
CONFIGURE_OPTIONS+=" -confirm-license"
CONFIGURE_OPTIONS+=" -c++std c++14"
CONFIGURE_OPTIONS+=" -qt-libpng -no-eglfs -dbus-runtime"
CONFIGURE_OPTIONS+=" -skip qtwebengine"
CONFIGURE_OPTIONS+=" -skip wayland"
CONFIGURE_OPTIONS+=" -skip qtgamepad"
CONFIGURE_OPTIONS+=" -system-freetype"
CONFIGURE_OPTIONS+=" -pkg-config"

#CONFIGURE_OPTIONS+=" -sysroot $(xcrun --show-sdk-path)"

if [ "$DIST_NAME" = "macOS" ]; then
    CONFIGURE_OPTIONS+=" -no-assimp"
    CONFIGURE_OPTIONS+=" QMAKE_APPLE_DEVICE_ARCHS=arm64"
    CONFIGURE_OPTIONS+=" QMAKE_CXXFLAGS+=-Wno-enum-constexpr-conversion"
else
    CONFIGURE_OPTIONS+=" -no-rpath"
fi

# qt-harfbuzz - see spns #9694
CONFIGURE_OPTIONS+=" -no-harfbuzz"
CONFIGURE_OPTIONS+=" -no-feature-geoservices_mapboxgl"

if [ -n "$OPENSSL_ROOT_DIR" ]; then 
    CONFIGURE_OPTIONS+=" -ssl  -openssl -I $OPENSSL_PREFIX/include"
    CONFIGURE_OPTIONS+=" -openssl-linked OPENSSL_PREFIX=$OPENSSL_ROOT_DIR"
else
    CONFIGURE_OPTIONS+=" -no-openssl"
fi

echo "*** SED"
if [ "$DIST_NAME" = "macOS" ]; then
    sed -i "" -e "s#Assistant.app/Contents/MacOS/Assistant#Assistant" $SOURCE_DIR/qttools/src/designer/src/designer/assistantclient.cpp 
    sed -i "" -e "s#Assistant.app/Contents/MacOS/Assistant#Assistant" $SOURCE_DIR/qttools/src/linguist/linguist/mainwindow.cpp 
fi

echo
echo "*** configure ${CONFIGURE_OPTIONS}"
$SOURCE_DIR/configure ${CONFIGURE_OPTIONS}
if [ $? -ne 0 ]; then

    echo "ERROR on configure"
    echo "**********************"
    echo "$DYLD_LIBRARY_PATH"
    echo "**********************"
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

# make clean pour nettoyer les sources
echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]; then
    echo "ERROR on make clean"
    exit 5
fi
#
#if [ "${SINGULARITY_NAME}" != "" ]; then
#    for f in $(ls ${PRODUCT_INSTALL}/lib/libQt5Core.so*); do
#        test -L $f
#        if [ $? -ne 0 ]; then
#            echo "INFO: stripping $f"
#            strip --remove-section=.note.ABI-tag ${f}
#        fi
#    done
#fi
#
echo
echo "########## END"
