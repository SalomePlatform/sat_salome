#!/bin/bash

echo "##########################################################################"
echo "graphviz" $VERSION
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
CMAKE_OPTIONS+=" -DPython3_ROOT_DIR=$PYTHON_ROOT_DIR"
CMAKE_OPTIONS+=" -DPython3_EXECUTABLE=$PYTHON_ROOT_DIR/bin/python3"

if [ "$DIST_NAME" = "macOS" ]; then
    CMAKE_OPTIONS+=" $SAT_CMAKE_OPTIONS"
    export PKG_CONFIG_PATH=$LIBPNG_ROOT_DIR/lib/pkgconfig:$PIXMAN_ROOT_DIR/lib/pkgconfig:${CAIRO_ROOT_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
    CMAKE_OPTIONS+=" -DJPEG_LIBRARY=${LIBJPEG_ROOT_DIR}/lib/libjpeg.dylib"
    CMAKE_OPTIONS+=" -DJPEG_INCLUDE_DIR=${LIBJPEG_ROOT_DIR}/include"
    CMAKE_OPTIONS+=" -DCMAKE_PREFIX_PATH=${CAIRO_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DCairo_INCLUDE_DIRS=${CAIRO_ROOT_DIR}/include/cairo"
    CMAKE_OPTIONS+=" -DCairo_LIBRARIES=${CAIRO_ROOT_DIR}/lib"
fi


echo "*** cmake" $CMAKE_OPTIONS
cmake --fresh $CMAKE_OPTIONS $SOURCE_DIR

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

export PATH=$PRODUCT_INSTALL/bin:$PATH
cd $PRODUCT_INSTALL/bin
dot -c
if [ $? -ne 0 ]
then
    echo "ERROR on configure dot -c"
    exit 4
fi


echo
echo "########## END"
