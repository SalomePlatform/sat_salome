#!/bin/bash

echo "##########################################################################"
echo "Qt" $VERSION
echo "##########################################################################"



echo
echo "*** configure"
CXXFLAGS="-fpermissive" $SOURCE_DIR/configure -prefix $PRODUCT_INSTALL -release -opensource -no-rpath \
    -verbose -no-separate-debug-info -confirm-license -qt-libpng -qt-xcb 
#-no-egl -no-eglfs -no-use-gold-linker
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

if [[ $BITS == "64" ]]
then
    echo "*** create link for lib64"
    cd $PRODUCT_INSTALL
    ln -s lib lib64
fi

echo
echo "########## END"

