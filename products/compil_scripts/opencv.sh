#!/bin/bash

echo "##########################################################################"
echo "opencv" $VERSION
echo "##########################################################################"

function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"

if version_ge $VERSION "3."; then
    echo "*** openCV version $VERSION >= 3."
    CMAKE_OPTIONS+=" -DBUILD_NEW_PYTHON_SUPPORT=ON"
    CMAKE_OPTIONS+=" -DBUILD_EXAMPLES:BOOL=ON"
    CMAKE_OPTIONS+=" -DPYTHON3_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python"
    CMAKE_OPTIONS+=" -DPYTHON3_NUMPY_INCLUDE_DIRS=${NUMPY_INCLUDE_DIR};${NUMPY_INCLUDE_DIR2}"
    CMAKE_OPTIONS+=" -DWITH_IPP:BOOL=OFF"
    CMAKE_OPTIONS+=" -DBUILD_opencv_java:BOOL=OFF"
    CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
    CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR2=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
    CMAKE_OPTIONS+=" -DWITH_FFMPEG:BOOL=OFF"
    CMAKE_OPTIONS+=" -DWITH_LAPACK:BOOL=OFF"
    CMAKE_OPTIONS+=" -DWITH_CUDA:BOOL=OFF"
    # bos 19730
    CMAKE_OPTIONS+=" -DWITH_VTK:BOOL=OFF"
    CMAKE_OPTIONS+=" -DENABLE_PRECOMPILED_HEADERS:BOOL=OFF"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS=-fPIC"
    CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=-fPIC"

    # 
else
    echo "*** openCV version $VERSION < 3."
    CMAKE_OPTIONS+=" -DWITH_CUDA:BOOL=OFF"
    CMAKE_OPTIONS+=" -DWITH_FFMPEG:BOOL=OFF"
    # OP opencv on Ubuntu
    CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python"
    CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIRS=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
    CMAKE_OPTIONS+=" -DPYTHON_LIBRARY=${PYTHON_ROOT_DIR}/lib/libpython${PYTHON_VERSION}.so"
    CMAKE_OPTIONS+=" -DBUILD_opencv_java=OFF"
fi


rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake $CMAKE_OPTIONS $SOURCE_DIR

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

echo
echo "########## END"

