#!/bin/bash

echo "##########################################################################"
echo "Petsc" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -rf $SOURCE_DIR/* .

CONFIGURE_FLAGS=''
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-f2cblaslapack=ext/f2cblaslapack-3.4.2.q4"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-slepc=ext/slepc-3.14.0"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --with-debugging=0" # by default Petsc is build in debug mode
echo
if [-n "$SAT_HPC" ] && [ -n "$MPI_ROOT_DIR" ]; then
  echo "*** configure with mpi"
  CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-hypre=ext/hypre-2.20.0"
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi-dir=${MPI_ROOT_DIR} ${CONFIGURE_FLAGS}
else
  echo "*** configure without mpi"
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi=0 ${CONFIGURE_FLAGS}
fi

if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 1
fi

MAKE_OPTIONS="PETSC_DIR=${BUILD_DIR}"

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make $MAKE_OPTIONS install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

