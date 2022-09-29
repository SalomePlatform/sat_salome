#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "TTK" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DTK_BUILD_PARAVIEW_PLUGINS=ON"

echo
echo "*** cmake" $CMAKE_OPTIONS
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd  $BUILD_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
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
