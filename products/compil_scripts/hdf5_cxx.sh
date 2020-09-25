#!/bin/bash

echo "##########################################################################"
echo "hdf5" $VERSION
echo "##########################################################################"



#if [[ $BITS == "64" ]]
#then
#   CONFIGURE_FLAGS="-m64 CXXFLAGS=-m64"
#fi

CONFIGURE_FLAGS=''

if [ -n "$SAT_HPC" ]
then
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-parallel --enable-shared"
else
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-threadsafe"
fi

echo "*** configure"
$SOURCE_DIR/configure --prefix=${PRODUCT_INSTALL} --disable-debug \
    --enable-production --enable-cxx --enable-unsupported \
    --with-pthread=/usr/include,/usr/lib \
    --with-default-api-version=v16 ${CONFIGURE_FLAGS}
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
