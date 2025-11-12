#!/bin/bash


echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

CMAKE_OPTIONS=

if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
fi

CMAKE_OPTIONS+=" -DBUILD_TESTING:BOOL=OFF"
CMAKE_OPTIONS+=" -DBUILD_EXAMPLES:BOOL=OFF"  
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_NAME_DIR:PATH=$PRODUCT_INSTALL/lib"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_INCLUDEDIR:STRING=include"
CMAKE_OPTIONS+=" -DISPC_EXECUTABLE:PATH=${ISPC_ROOT_DIR}/bin/ispc"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -S$SOURCE_DIR"
CMAKE_OPTIONS+=" -B$BUILD_DIR"


echo
echo "*** cmake ${CMAKE_OPTIONS}"
cmake $CMAKE_OPTIONS
if [ $? -ne 0 ]; then
   echo "ERROR on cmake"
   exit 1
fi

cd $BUILD_DIR

echo
echo "*** make ${MAKE_OPTIONS}"
make ${MAKE_OPTIONS}
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
