#!/bin/bash

echo "##########################################################################"
echo "ispc $VERSION"
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR=lib"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DISPC_INCLUDE_EXAMPLES:BOOL=OFF"
CMAKE_OPTIONS+=" -DISPC_INCLUDE_TESTS=OFF"
CMAKE_OPTIONS+=" -DISPC_INCLUDE_UTILS:BOOL=OFF"

cd ${BUILD_DIR}

echo
echo "*** cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}"
cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** make ${MAKE_OPTIONS}"
make ${MAKE_OPTIONS}
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
