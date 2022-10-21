#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "TTK" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DTTK_BUILD_PARAVIEW_PLUGINS=ON"
CMAKE_OPTIONS+=" -Dembree_DIR:PATH=${EMBREE_ROOT_DIR}/lib/cmake/embree-${EMBREE_VERSION}"
# Embree CMake defines EMBREE_INCLUDE_DIRS but TTK uses EMBREE_INCUDE_DIR which is undefined.
CMAKE_OPTIONS+=" -DEMBREE_INCLUDE_DIR=${EMBREE_ROOT_DIR}/include"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

case $LINUX_DISTRIBUTION in
    DB09|DB10)
        # A.Geay (Sous debian10 sur nos VM de prod, on a pas mal de nos tests qui plantent avec des SIGILL)
        # D.Hoang: application à Debian 9
        echo "WARNING: switching off cpu optimization!"
        CMAKE_OPTIONS+=" -DTTK_ENABLE_CPU_OPTIMIZATION=OFF"
        ;;
    *)
        ;;
esac

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
