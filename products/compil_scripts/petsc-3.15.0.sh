#!/bin/bash

echo "##########################################################################"
echo "Petsc" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -rf $SOURCE_DIR/* .

CONFIGURE_FLAGS=''
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-f2cblaslapack=ext/f2cblaslapack-3.4.2.q4.tar.gz"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-slepc=ext/slepc-3.15.0.tar.gz"
if [ "$SAT_hdf5_IS_NATIVE" != "1" ]; then
    CONFIGURE_FLAGS+=" --with-hdf5-dir=${HDF5_ROOT_DIR}"
fi
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-metis=ext/metis-5.1.0-p10.tar.gz"
CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --with-debugging=0" # by default Petsc is build in debug mode
echo
if [-n "$SAT_HPC" ] && [ -n "$MPI_ROOT_DIR" ]; then
  echo "*** configure with mpi"
  CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-hypre=ext/hypre-2.20.0.tar.gz"
  CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-parms=ext/parms-3.2-p5.tar.gz"
  CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-parmetis=ext/parmetis-4.0.3-p6.tar.gz"
  CONFIGURE_FLAGS=$CONFIGURE_FLAGS" --download-ptscotch=ext/scotch_6.1.0.tar.gz"
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi-dir=${MPI_ROOT_DIR} ${CONFIGURE_FLAGS}
else
  echo "*** configure without mpi"
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi=0 ${CONFIGURE_FLAGS}
fi

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

# CentOS 6 automatically set PETSC_ARCH to arch-linux2-c-debug : remove arch specification
# MAKE_OPTIONS=$MAKE_OPTIONS" PETSC_ARCH=arch-linux-c-debug"

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

