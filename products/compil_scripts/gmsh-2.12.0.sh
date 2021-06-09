#!/bin/bash

echo "##########################################################################"
echo "gmsh" $VERSION
echo "##########################################################################"



CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DENABLE_ACIS=0"
CMAKE_OPTIONS+=" -DENABLE_BUILD_SHARED=1"
CMAKE_OPTIONS+=" -DENABLE_FLTK=0"
CMAKE_OPTIONS+=" -DENABLE_MED=0"
CMAKE_OPTIONS+=" -DENABLE_ONELAB_METAMODEL=0"
CMAKE_OPTIONS+=" -DENABLE_PARSER=0"
CMAKE_OPTIONS+=" -DENABLE_SALOME=0"
CMAKE_OPTIONS+=" -DENABLE_PETSC:BOOL=OFF" #pour éviter de tirer sur MPI


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
cp -f --backup=numbered `find $SOURCE_DIR -name "*.h"` $PRODUCT_INSTALL/include/ && mv $PRODUCT_INSTALL/include/gmsh/* $PRODUCT_INSTALL/include/ && rmdir $PRODUCT_INSTALL/include/gmsh/
if [ $? -ne 0 ]
then
    echo "ERROR on copy"
    exit 3
fi


echo
echo "########## END"

