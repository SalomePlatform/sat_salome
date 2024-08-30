#!/bin/bash


echo "##########################################################################"
echo FMILibrary $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
CMAKE_OPTIONS+=" -DFMILIB_GENERATE_DOXYGEN_DOC=OFF"
CMAKE_OPTIONS+=" -DFMILIB_INSTALL_PREFIX=${PRODUCT_INSTALL}"

cd $BUILD_DIR

echo
echo "*** cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}"
if ! cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}; then
    echo "error on cmake"
fi

echo
echo "*** make ${MAKE_OPTIONS}"
if ! make ${MAKE_OPTIONS}; then
    echo "Error on make ${MAKE_OPTIONS}"
fi

echo
echo "*** make install"
if ! make install; then
    echo "error on make install"
fi

echo
echo "############## END"
