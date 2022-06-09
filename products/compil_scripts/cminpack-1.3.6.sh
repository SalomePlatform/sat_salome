#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "Cminpack " $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""

if [-n "$SAT_HPC" ] && [ -n "$MPI_ROOT_DIR" ]; then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER}"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER}"
fi

CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DUSE_BLAS=ON"
CMAKE_OPTIONS+=" -DUSE_FPIC=ON"
CMAKE_OPTIONS+=" -DBUILD_EXAMPLES=OFF"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
# strangely on CentOS 8 - CMake fails to find CBLAS include directory
if [[ $DIST_NAME == "CO" && $DIST_VERSION == "8" && -d /usr/include/cblas ]]; then
    CMAKE_OPTIONS+=" -DCBLAS_INCLUDE_DIRS=/usr/include/cblas "
# Blas/Lapack
elif [ -n "$LAPACK_ROOT_DIR" ] && [ "${SAT_lapack_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DLAPACK_DIR=${LAPACK_ROOT_DIR}/lib/cmake/lapack-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_DIR=${LAPACK_ROOT_DIR}/lib/cmake/cblas-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libcblas.so"
    CMAKE_OPTIONS+=" -DBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libblas.so"
    CMAKE_OPTIONS+=" -DCBLAS_INCLUDE_DIRS=${LAPACK_ROOT_DIR}/include "
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
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
echo "*** check installation"

if [ -d "${PRODUCT_INSTALL}/lib64" ]
then
    echo "WARNING: renaming lib64 to lib..."
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"
