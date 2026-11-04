#!/bin/bash

echo "##########################################################################"
echo "embree" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

CMAKE_OPTIONS=
# common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_VERBOSE_MAKEFILE=ON"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
CMAKE_OPTIONS+=" -DENABLE_BUILD_SHARED=ON"
CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD=14"

CMAKE_OPTIONS+=" -DEMBREE_ISPC_SUPPORT=ON "
CMAKE_OPTIONS+=" -DEMBREE_TUTORIALS=OFF"
CMAKE_OPTIONS+=" -DEMBREE_TASKING_SYSTEM=TBB"
CMAKE_OPTIONS+=" -DTBB_ROOT=$TBB_ROOT_DIR"
CMAKE_OPTIONS+=" -DEMBREE_MAX_ISA=NEON"

if [ "$DIST_NAME" = "macOS" ]; then
    CMAKE_OPTIONS+=" $SAT_CMAKE_OPTIONS"
fi

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR

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

