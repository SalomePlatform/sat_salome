#!/bin/bash

echo "##########################################################################"
echo "meshboolean" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo "##########################################################################"
echo "cgal" $VERSION
echo "##########################################################################"

mkdir $BUILD_DIR/cgal
cd $BUILD_DIR/cgal

CMAKE_OPTIONS=
# common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
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
echo "libigl" $VERSION
echo "##########################################################################"

mkdir $BUILD_DIR/libigl
cd $BUILD_DIR/libigl

CMAKE_OPTIONS=
# common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

# overwrite the main.cpp
cp -f $SOURCE_DIR/libigl/main.cpp $SOURCE_DIR/libigl/libigl/tutorial/609_Boolean/main.cpp

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR/libigl/libigl

if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
cd $BUILD_DIR/libigl/tutorial
make $MAKE_OPTIONS tutorial/CMakeFiles/609_Boolean.dir/rule 
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
mkdir -p ${PRODUCT_INSTALL}/bin
cp $BUILD_DIR/libigl/bin/609_Boolean ${PRODUCT_INSTALL}/bin
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi
chmod 755 ${PRODUCT_INSTALL}/bin/609_Boolean

echo
echo "########## END"
