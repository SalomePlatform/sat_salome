#!/bin/bash

echo "##########################################################################"
echo "hdf5" $VERSION
echo "##########################################################################"


echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH

CONFIGURE_FLAGS=''
# --enable-shared is set by default 
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-unsupported"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-hl"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-build-mode=production"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --disable-silent-rules"

if [ -n "$SAT_HPC" ]
then
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-parallel"
#    export FC=mpif90
#    export CXX=mpicxx
#    export CC=mpiCC
else
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-threadsafe"
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --enable-cxx"  # not compatible with --enable-parallel
fi

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
