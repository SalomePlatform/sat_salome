#!/bin/bash

echo ##########################################################################
echo "$PRODUCT_NAME $VERSION"
echo ##########################################################################

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR

export CC=$(which gcc)
export FC=$(which gfortran)
export CXX=$(which g++)

CMAKE_OPTIONS="$SOURCE_DIR"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=$PRODUCT_INSTALL"

if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=-fPIC"
CMAKE_OPTIONS+=" -DBUILD_BENCHMARKS=ON"
CMAKE_OPTIONS+=" -DDYNAMIC_ARCH=ON"
CMAKE_OPTIONS+=" -DDYNAMIC_OLDER=ON"
CMAKE_OPTIONS+=" -DUSE_THREAD=ON"
CMAKE_OPTIONS+=" -DTARGET=GENERIC"
CMAKE_OPTIONS+=" -DBINARY=64"
CMAKE_OPTIONS+=" -DMAX_THREADS=64"

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

