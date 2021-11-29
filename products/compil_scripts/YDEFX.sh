#!/bin/bash

echo "##########################################################################"
echo "YDEFX" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCONFIGURATION_ROOT_DIR=${CONFIGURATION_ROOT_DIR}"
CMAKE_OPTIONS+=" -DKERNEL_ROOT_DIR=${KERNEL_ROOT_DIR}"
CMAKE_OPTIONS+=" -DCMAKE_PREFIX_PATH=\"$KERNEL_ROOT_DIR/salome_adm/cmake_files;$PY2CPP_ROOT_DIR/lib/cmake/py2cpp/;\" "
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DPYTHON_ROOT_DIR=${PYTHON_ROOT_DIR}"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
CMAKE_OPTIONS+=" -DPYTHON_LIBRARY=${PYTHON_ROOT_DIR}/lib/libpython${PYTHON_VERSION}.so"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

MAKE_OPTIONS="VERBOSE=1 "$MAKE_OPTIONS
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi
