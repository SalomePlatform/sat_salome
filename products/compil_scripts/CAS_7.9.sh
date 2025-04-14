#!/bin/bash

echo "##########################################################################"
echo "OCCT " $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DUSE_TCL=OFF"
CMAKE_OPTIONS+=" -DBUILD_MODULE_Draw=OFF"
CMAKE_OPTIONS+=" -DUSE_FREETYPE=ON -D3RDPARTY_FREETYPE_DIR=$FREETYPEDIR"
CMAKE_OPTIONS+=" -DUSE_FREEIMAGE=ON -D3RDPARTY_FREEIMAGE_DIR=$FREEIMAGEDIR"
CMAKE_OPTIONS+=" -DUSE_RAPIDJSON=ON -D3RDPARTY_RAPIDJSON_DIR=$RAPIDJSONDIR"
CMAKE_OPTIONS+=" -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
if [ $? -ne 0 ]; then
    echo "ERROR on cmake"
    exit 1
fi

MAKE_OPTIONS="VERBOSE=1 "$MAKE_OPTIONS
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

# see bos #45011
OCCT_TARGETS_CMAKE_FILE=${PRODUCT_INSTALL}/lib/cmake/opencascade/OpenCASCADEVisualizationTargets.cmake

if [ "$SAT_freetype_IS_NATIVE" != "1" ]; then
    sed -i "s#libfreetype.so#${FREETYPE_ROOT_DIR}/lib/libfreetype.so#g" $OCCT_TARGETS_CMAKE_FILE
    if [ $? -ne 0 ]; then
	echo "ERROR: could not patch ${OCCT_TARGETS_CMAKE_FILE}"
	exit 4
    fi
fi

if [ "$SAT_freeimage_IS_NATIVE" != "1" ]; then
    sed -i "s#libfreeimage.so#${FREEIMAGE_ROOT_DIR}/lib/libfreeimage.so#g" $OCCT_TARGETS_CMAKE_FILE
    if [ $? -ne 0 ]; then
	echo "ERROR: could not patch ${OCCT_TARGETS_CMAKE_FILE}"
	exit 4
    fi
fi

echo
echo "########## END"
