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

if [ -n "$SINGULARITY_NAME" ]; then
    echo "WARNING: singularity env detected. applying ABI-tag patch"
    PATCH_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/../patches
    cd $SOURCE_DIR
    patch -Nbp1 -i $PATCH_DIR/qt_5_15_2_remove_ABI_tag.patch
fi

if [ -n "$SAT_DEBUG" ]; then
    BUILD_TYPE="-debug"
else
    BUILD_TYPE="-release"
fi

# clean build directory
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR && cd $BUILD_DIR

# For -qt-harfbuzz option, see spns #9694
echo
echo "*** configure -prefix $PRODUCT_INSTALL $BUILD_TYPE -opensource -nomake tests -nomake examples -no-rpath -verbose -no-separate-debug-info -confirm-license -qt-libpng -xcb -no-eglfs -dbus-runtime -skip qtwebengine -skip wayland -skip qtgamepad -system-freetype -qt-harfbuzz -no-openssl -no-glib -no-jasper"

$SOURCE_DIR/configure -prefix $PRODUCT_INSTALL $BUILD_TYPE -opensource -nomake tests -nomake examples -no-rpath \
    -verbose -no-separate-debug-info -confirm-license -qt-libpng -xcb -no-eglfs -dbus-runtime -skip qtwebengine \
    -skip wayland -skip qtgamepad -system-freetype -qt-harfbuzz \
    -no-openssl -no-glib -no-jasper

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

# make clean pour nettoyer les sources
echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]; then
    echo "ERROR on make clean"
    exit 5
fi

if [ "${SINGULARITY_NAME}" != "" ]; then
    for f in $(ls ${PRODUCT_INSTALL}/lib/libQt5Core.so*); do
        test -L $f
        if [ $? -ne 0 ]; then
            echo "INFO: stripping $f"
            strip --remove-section=.note.ABI-tag ${f}
        fi
    done
fi

echo
echo "########## END"

