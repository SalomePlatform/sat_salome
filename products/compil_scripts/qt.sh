#!/bin/bash

echo "##########################################################################"
echo "Qt" $VERSION
echo "##########################################################################"

cd $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on $SOURCE_DIR access"
    exit 1
fi

if [[ $DIST_NAME == "FD" && $DIST_VERSION == "32" ]]
then
    export  QMAKE_CXXFLAGS="-std=c++11"
fi

if [ -n "$SAT_DEBUG" ]
then
    BUILD_TYPE="-debug"
else
    BUILD_TYPE="-release"
fi

# For -qt-harfbuzz option, see spns #9694
echo
echo "*** ./configure -prefix $PRODUCT_INSTALL $BUILD_TYPE -opensource -nomake tests -nomake examples -no-rpath -verbose -no-separate-debug-info -confirm-license -qt-libpng -qt-xcb -no-eglfs -dbus-runtime -skip qtwebengine -skip wayland -skip qtgamepad -system-freetype -qt-harfbuzz -no-openssl -no-glib"

./configure -prefix $PRODUCT_INSTALL $BUILD_TYPE -opensource -nomake tests -nomake examples -no-rpath \
    -verbose -no-separate-debug-info -confirm-license -qt-libpng -qt-xcb -no-eglfs -dbus-runtime -skip qtwebengine \
    -skip wayland -skip qtgamepad -system-freetype -qt-harfbuzz \
    -no-openssl -no-glib

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

# make clean pour nettoyer les sources
echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]
then
    echo "ERROR on make clean"
    exit 5
fi

echo
echo "########## END"

