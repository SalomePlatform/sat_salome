#!/bin/bash

echo "##########################################################################"
echo "ospray" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

cp -r $SOURCE_DIR $BUILD_DIR

CMAKE_OPTIONS=
# common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_VERBOSE_MAKEFILE=ON"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DENABLE_BUILD_SHARED=ON"
CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD=14"

CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER=clang++"
CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER=clang"
CMAKE_OPTIONS+=" -DEMBREE_ISPC_SUPPORT=ON"
CMAKE_OPTIONS+=" -DEMBREE_TUTORIALS=OFF"

CMAKE_OPTIONS+=" -DBUILD_EMBREE_FROM_SOURCE=OFF"
CMAKE_OPTIONS+=" -DBUILD_OPENVKL_FROM_SOURCE=OFF"
CMAKE_OPTIONS+=" -DBUILD_RKCOMMON_FROM_SOURCE=OFF"

CMAKE_OPTIONS+=" -Dembree_DIR=${embree_DIR}" 
CMAKE_OPTIONS+=" -DOSPRAY_ENABLE_APPS=OFF"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR=lib"
CMAKE_OPTIONS+=" -Drkcommon_DIR=${rkcommon_DIR}"
CMAKE_OPTIONS+=" -Dispcrt_DIR=${ispcrt_DIR}"
CMAKE_OPTIONS+=" -Dopenvkl_DIR=${openvkl_DIR}"
CMAKE_OPTIONS+=" -DCMAKE_SYSTEM_PROCESSOR=aarch64"
CMAKE_OPTIONS+=" -DOSPRAY_ISPC_TARGET=neon-i32x4"
CMAKE_OPTIONS+=" -DOSPRAY_ISPC_TARGET_LIST=neon"
CMAKE_OPTIONS+=" -DOSPRAY_BUILD_ISA=NEON"

if [ "$DIST_NAME" = "macOS" ]; then
    CMAKE_OPTIONS+=" $SAT_CMAKE_OPTIONS"
fi

export ISPC_ARGS="--arch=aarch64 --target=neon-i32x4"

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
#cmake ospray/scripts/superbuild $CMAKE_OPTIONS

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
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

