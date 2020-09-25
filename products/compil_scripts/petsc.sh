#!/bin/bash

echo "##########################################################################"
echo "Petsc" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* .

echo
echo "*** configure"
./configure --prefix=$PRODUCT_INSTALL --with-mpi=0 --download-f2cblaslapack=https://www.mcs.anl.gov/petsc/mirror/externalpackages/f2cblaslapack-3.4.2.q4.tar.gz --download-slepc=https://slepc.upv.es/download/distrib/slepc-3.13.4.tar.gz

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

MAKE_OPTIONS="PETSC_DIR=${BUILD_DIR}"

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

MAKE_OPTIONS=$MAKE_OPTIONS" PETSC_ARCH=arch-linux-c-debug"

echo
echo "*** make install"
make $MAKE_OPTIONS install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

