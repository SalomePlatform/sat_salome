#!/bin/bash

echo "##########################################################################"
echo "gcc" $VERSION
echo "##########################################################################"

CONFIGURE_FLAGS=''
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-languages=c,c++,fortran"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-checking=release"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --disable-multilib"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-shared=yes"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-threads=posix"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-plugins"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-ld"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-bootstrap"

echo "*** configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_FLAGS}"
$SOURCE_DIR/configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_FLAGS}
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

echo
echo "########## END"
