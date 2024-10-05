#!/bin/bash

echo "##########################################################################"
echo "libigl" $VERSION
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

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR

if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
cd tutorial
make $MAKE_OPTIONS tutorial/CMakeFiles/609_Boolean.dir/rule 
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
mkdir -p ${PRODUCT_INSTALL}/bin
cp $BUILD_DIR/bin/609_Boolean ${PRODUCT_INSTALL}/bin
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi
chmod 755 ${PRODUCT_INSTALL}/bin/609_Boolean

cp -r ${SOURCE_DIR}/include ${PRODUCT_INSTALL}/include
if [ $? -ne 0 ]; then
    echo "ERROR on make install: could not copy include directory..."
    exit 4
fi

echo
echo "########## END"
