#!/bin/bash

echo "##########################################################################"
echo "cgal" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DWITH_examples=ON"
CMAKE_OPTIONS+=" -DWITH_tests=ON"
CMAKE_OPTIONS+=" -DWITH_demos=ON"
CMAKE_OPTIONS+=" -DCGAL_ENABLE_TESTING=ON"

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
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

echo "##########################################################################"
echo "Building cgal_test"
echo "##########################################################################"

mkdir $BUILD_DIR/cgal_test
cd $BUILD_DIR/cgal_test
CMAKE_OPTIONS=
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS_COMMON+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS_COMMON+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DCGAL_DIR=${PRODUCT_INSTALL}/lib/cmake"
CMAKE_OPTIONS+=" -DEXECUTABLE_OUTPUT_PATH=${PRODUCT_INSTALL}/bin"
echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR/cgal_test
if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
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
