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

CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" -prefix $PRODUCT_INSTALL"
CONFIGURE_OPTIONS+=" $BUILD_TYPE"
CONFIGURE_OPTIONS+=" -opensource"
CONFIGURE_OPTIONS+=" -nomake tests"
CONFIGURE_OPTIONS+=" -nomake examples"
CONFIGURE_OPTIONS+=" -no-rpath"
CONFIGURE_OPTIONS+=" -verbose -no-separate-debug-info -confirm-license"
CONFIGURE_OPTIONS+=" -qt-libpng -xcb -no-eglfs -dbus-runtime"
CONFIGURE_OPTIONS+=" -skip qtwebengine"
CONFIGURE_OPTIONS+=" -skip wayland"
CONFIGURE_OPTIONS+=" -skip qtgamepad"
CONFIGURE_OPTIONS+=" -system-freetype"
# qt-harfbuzz - see spns #9694
CONFIGURE_OPTIONS+=" -qt-harfbuzz"
CONFIGURE_OPTIONS+=" -no-openssl"
CONFIGURE_OPTIONS+=" -no-glib"
CONFIGURE_OPTIONS+=" -no-jasper"

echo
echo "*** configure ${CONFIGURE_OPTIONS}"
$SOURCE_DIR/configure ${CONFIGURE_OPTIONS}
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

