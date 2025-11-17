#!/bin/bash

echo "##########################################################################"
echo "gmsh" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

CMAKE_OPTIONS=
# common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_VERBOSE_MAKEFILE=ON"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=Release"
CMAKE_OPTIONS+=" -DENABLE_BUILD_SHARED=ON"

# build options
echo "*** GMSH version $VERSION >= 4."
CMAKE_OPTIONS+=" -DENABLE_ACIS=OFF"
CMAKE_OPTIONS+=" -DENABLE_FLTK=OFF"
CMAKE_OPTIONS+=" -DENABLE_MED=ON"
CMAKE_OPTIONS+=" -DENABLE_ONELAB_METAMODEL=OFF"
CMAKE_OPTIONS+=" -DENABLE_PARSER=ON"
CMAKE_OPTIONS+=" -DENABLE_PETSC=OFF"
CMAKE_OPTIONS+=" -DENABLE_PRIVATE_API=ON"
CMAKE_OPTIONS+=" -DENABLE_CGNS=ON"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR=${PRODUCT_INSTALL}/lib" # strangely on Ubuntu GMSH installs the .so in lib instead of lib/lib64 - so force to lib64
CMAKE_OPTIONS+=" -DCMAKE_PREFIX_PATH=${LAPACK_ROOT_DIR};${HDF5_ROOT_DIR};${MEDFILE_ROOT_DIR};${CGNS_ROOT_DIR};" # set path of third libraries to our associated internal products
CMAKE_OPTIONS+=" -DENABLE_OPENMP=ON"     # get OpenMP based parallelism working
CMAKE_OPTIONS+=" -DENABLE_PLUGINS=OFF"   # needed for correct GmshFinalize() after version 4.3.0
if [[ $DIST_NAME == "FD" && $DIST_VERSION == "32" ]]
then
    CMAKE_OPTIONS+=" -DENABLE_MMG3D=OFF" # removed anyhow in GMS 4.6
fi
CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD=14"
if [ -n "$SAT_HPC" ]
then
    if [ -n "$MPI_ROOT_DIR" ]; then
	CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=$(which mpic++)"
	CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=$(which mpicc)"
    fi
fi

# spns #47907 -  switch on python wrapper
CMAKE_OPTIONS+=" -DWRAP_PYTHON=ON"

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
if [ -n "$SALOME_GMSH_HEADERS_STD" ]; then
    echo "Using standard directory structure"
else
    echo "*** copy all .h in sources to install"
    cp -f --backup=numbered `find $SOURCE_DIR -name "*.h"` $PRODUCT_INSTALL/include/ && \
        mv $PRODUCT_INSTALL/include/gmsh/* $PRODUCT_INSTALL/include/ && \
        rmdir $PRODUCT_INSTALL/include/gmsh/
    if [ $? -ne 0 ]
    then
        echo "ERROR on copy"
        exit 4
    fi
fi

echo
echo "########## END"

