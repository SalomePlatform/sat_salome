#!/bin/bash

echo "##########################################################################"
echo "eficas" $VERSION
echo "##########################################################################"



CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DIN_SALOME_CONTEXT:BOOL=ON"
CMAKE_OPTIONS+=" -DWITH_ALL_PACKAGES:BOOL=ON"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python${PYTHON_VERSION}"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_PATH=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
CMAKE_OPTIONS+=" -DPYTHON_LIBRARY=${PYTHON_ROOT_DIR}/lib/libpython${PYTHON_VERSION}.so"

mkdir -p $BUILD_DIR
cd $BUILD_DIR

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

