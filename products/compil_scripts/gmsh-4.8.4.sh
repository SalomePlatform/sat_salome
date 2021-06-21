#!/bin/bash

echo "##########################################################################"
echo "gmsh" $VERSION
echo "##########################################################################"



CMAKE_OPTIONS=""
# common settings
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_VERBOSE_MAKEFILE=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_BUILD_TYPE=Release"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_BUILD_SHARED=ON"

# build options
echo "*** GMSH version $VERSION >= 4."
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_ACIS=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_FLTK=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_MED=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_ONELAB_METAMODEL=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_PARSER=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_PETSC=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_PRIVATE_API=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_CGNS=OFF" # default value is set to ON in release 4.1.4
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_LIBDIR=${PRODUCT_INSTALL}/lib" # strangely on Ubuntu GMSH installs the .so in lib instead of lib/lib64 - so force to lib64
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_PREFIX_PATH=${LAPACK_ROOT_DIR}" # set path of third libraries to our associated internal products
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_OPENMP=1"
if [[ $DIST_NAME == "FD" && $DIST_VERSION == "32" ]]
then
    CMAKE_OPTIONS="${CMAKE_OPTIONS} -DENABLE_MMG3D=OFF" # removed anyhow in GMS 4.6
fi

echo "*** cmake" $CMAKE_OPTIONS
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
echo "*** copy all .h in sources to install"
cp -f --backup=numbered `find $SOURCE_DIR -name "*.h"` $PRODUCT_INSTALL/include/ && \
    mv $PRODUCT_INSTALL/include/gmsh/* $PRODUCT_INSTALL/include/ && \
    rmdir $PRODUCT_INSTALL/include/gmsh/
if [ $? -ne 0 ]
then
    echo "ERROR on copy"
    exit 4
fi


echo
echo "########## END"

