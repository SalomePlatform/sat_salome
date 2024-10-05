#!/bin/bash

echo "##########################################################################"
echo "irm" $VERSION
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
echo "*** make install"
mkdir -p ${PRODUCT_INSTALL}/bin
for f in $(ls |grep mesh_booleans); do
    echo "INFO: next file: $f"
    F=${PRODUCT_INSTALL}/bin/$f
    mv ${BUILD_DIR}/$f $F
    if [ $? -ne 0 ]; then
        echo "ERROR on make install for file: $f"
        exit 4
    fi
    if [ ! -L "$F" ]; then
        chmod 755 $F
    fi
done

echo
echo "########## END"

