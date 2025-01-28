#!/bin/bash

echo "##########################################################################"
echo "Petsc" $VERSION
echo "##########################################################################"

NATIVE_PATH="/usr"
LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
echo "WARNING: "
case $LINUX_DISTRIBUTION in
    UB*|DB*)
        NATIVE_PATH="/usr/lib/x86_64-linux-gnu"
        ;;
    FD40)
        NATIVE_PATH="/usr/lib64"
        ;;
    *)
        ;;
esac

cp -r $SOURCE_DIR/* .

CONFIGURE_FLAGS=

CONFIGURE_FLAGS+="--download-slepc=ext/slepc-3.20.1.tar.gz"

if [ -f "${NATIVE_PATH}/liblapack.a" ] && [ "${SAT_lapack_IS_NATIVE}" == "1" ]; then
   CONFIGURE_FLAGS+=" --with-blaslapack=1"
elif [ -n "${LAPACK_ROOT_DIR}" ] && [ "${SAT_lapack_IS_NATIVE}" != "1" ]; then
   CONFIGURE_FLAGS+=" --with-blaslapack-dir=${LAPACK_ROOT_DIR}"
else
   CONFIGURE_FLAGS+=" --download-f2cblaslapack=ext/f2cblaslapack-3.8.0.q2.tar.gz"
fi

CONFIGURE_FLAGS+=" --with-python-dir=${PYTHON_ROOT_DIR}"
CONFIGURE_FLAGS+=" --with-hdf5-dir=${HDF5_ROOT_DIR}"

if [ -f "${NATIVE_PATH}/libfftw3.a" ] && [ "${SAT_fftw_IS_NATIVE}" == "1" ]; then
   CONFIGURE_FLAGS+=" --with-fftw=1"
elif [ -n "${FFTW_ROOT_DIR}" ] && [ "${SAT_fftw_IS_NATIVE}" != "1" ]; then
   CONFIGURE_FLAGS+=" --with-fftw-dir=${FFTW_ROOT_DIR}"
else
   CONFIGURE_FLAGS+=" --download-fftw=ext/fftw-3.3.10.tar.gz"
fi

CONFIGURE_FLAGS+=" --with-cuda=0" # 
CONFIGURE_FLAGS+=" --with-debugging=0" # by default Petsc is build in debug mode
CONFIGURE_FLAGS+=" --with-petsc4py=yes"
CONFIGURE_FLAGS+=" --download-slepc-configure-arguments=--with-slepc4py=yes"

if [ -f "${NATIVE_PATH}/libmetis.so" ] && [ "${SAT_metis_IS_NATIVE}" == "1" ]; then
    CONFIGURE_FLAGS+=" --with-metis=1"
elif [ -n "${METIS_ROOT_DIR}" ] && [ "${SAT_metis_IS_NATIVE}" != "1" ]; then
    CONFIGURE_FLAGS+=" --with-metis-dir=${METIS_ROOT_DIR}"
else
    CONFIGURE_FLAGS+=" --download-metis=ext/metis-5.1.0-p11.tar.gz"
fi

echo
if [ -n "${SAT_HPC}" ]; then
  CONFIUGRE_FLAGS+=" --with-med-dir=${MEDFILE_ROOT_DIR}"
  
  if [ -f "${NATIVE_PATH}/libHYPRE_core.so" ]; then
      CONFIGURE_FLAGS+=" --with-hypre=1"
  else
      CONFIGURE_FLAGS+=" --download-hypre=ext/hypre-2.29.0.tar.gz"
  fi
  
  if [ -f "${NATIVE_PATH}/libptscotch.so" ] && [ "${SAT_ptscotch_IS_NATIVE}" == "1" ]; then
      CONFIGURE_FLAGS+=" --with-ptscotch=1"
  elif [ -n "${PTSCOTCH_ROOT_DIR}" ] && [ "${SAT_ptscotch_IS_NATIVE}" != "1" ]; then 
      CONFIGURE_FLAGS+=" --with-ptscoth=${PTSCOTCH_ROOT_DIR}"
  else
      CONFIGURE_FLAGS+=" --download-ptscotch=ext/scotch_7.0.3.tar.gz"
  fi

  if [ -n "${MPI4PY_ROOT_DIR}" ]; then
      CONFIGURE_FLAGS+=" --with-mpi4py-dir=${MPI4PY_ROOT_DIR}"
  else
      CONFIGURE_FLAGS+=" --download-mpi4py=ext/mpi4py-3.1.5.tar.gz"
  fi

  CONFIGURE_FLAGS+=" --with-mpi-dir=${MPI_ROOT_DIR}"

else
   CONFIGURE_FLAGS+=" --with-mpi=0"
fi

CONFIGURE_FLAGS+=" --PETSC_ARCH=installed-arch-linux2-c-opt"
CONFIGURE_FLAGS+=" --PETSC_DIR=${BUILD_DIR}"

echo "*** configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_FLAGS}"
if ! ./configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_FLAGS}
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
if ! make "$MAKE_OPTIONS"
then
    echo "ERROR on make"
    exit 2
fi

# CentOS 6 automatically set PETSC_ARCH to arch-linux2-c-debug : remove arch specification
# MAKE_OPTIONS=$MAKE_OPTIONS" PETSC_ARCH=arch-linux-c-debug"

echo
echo "*** make install"
if ! make "$MAKE_OPTIONS" install
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** make check"
if ! make "$MAKE_OPTIONS" check
then
    echo "ERROR on make check"
    exit 4
fi

echo
echo "########## END"

