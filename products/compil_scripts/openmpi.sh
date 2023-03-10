#!/bin/bash

echo "##########################################################################"
echo "OpenMPI" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

cp -r $SOURCE_DIR/* .

if [ -f autogen.pl ] && [ ! -f configure ]; then
    echo
    echo "*** autoreconf -i"
    chmod +x autogen.pl
    ./autogen.pl
    if [ $? -ne 0 ]
    then
        echo "ERROR on autogen.pl"
        exit 1
    fi
fi

echo
echo "*** configure"
$BUILD_DIR/configure --prefix=$PRODUCT_INSTALL
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

