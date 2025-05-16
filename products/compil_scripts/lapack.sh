#!/bin/bash

echo "##########################################################################"
echo "lapack" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR

CMAKE_OPTIONS="$SOURCE_DIR"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=$PRODUCT_INSTALL"

if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS=-fPIC"
CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=-fPIC"
CMAKE_OPTIONS+=" -DUSE_OPTIMIZED_BLAS=OFF"
CMAKE_OPTIONS+=" -DCBLAS=ON"
CMAKE_OPTIONS+=" -DBLAS=ON"
CMAKE_OPTIONS+=" -DLAPACKE=ON"

echo
echo "*** cmake ${CMAKE_OPTIONS}"
cmake ${CMAKE_OPTIONS}
if [ $? -ne 0 ]; then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** make  ${MAKE_OPTIONS}"
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"

make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

