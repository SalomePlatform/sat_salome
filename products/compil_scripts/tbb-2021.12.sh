#!/bin/bash

echo "##########################################################################"
echo "tbb" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=$PRODUCT_INSTALL"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

echo
echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]; then
    echo "ERROR on cmake"
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

# apply a post-fix
LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
case $LINUX_DISTRIBUTION in
    DB12)
        echo "WARNING: Fixing tbb until Paraview version is updated: issue with tbb AND ParaView/vtk/vtk-m cmake files tbbbind target not found"
        sed -i 's/ TBB::tbbbind_2_5//g'  $PRODUCT_INSTALL/lib/cmake/TBB/TBBTargets.cmake
        ;;
    *)
        ;;
esac

