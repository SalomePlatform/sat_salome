#!/bin/bash

echo "##########################################################################"
echo "med" $VERSION
echo "##########################################################################"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR


# fPIC is not there by default in MED autotools ...
Wno="-Wno-error -Wno-implicit-function-declaration"
CFLAGS="${CFLAGS} -fPIC $Wno"
CPPFLAGS="${CPPFLAGS} -fPIC $Wno"
CXXFLAGS="${CXXFLAGS} -fPIC $Wno"
FFLAGS="${FFLAGS} -fPIC"

echo "Configuring with CMake ..."
export FFLAGS="${FFLAGS} -fdefault-integer-8"

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_STATIC_LIBS:BOOL=OFF"
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=$(sw_vers -productVersion)"
CMAKE_OPTIONS+=" -DMEDFILE_INSTALL_DOC=OFF"
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_PYTHON=OFF"
CMAKE_OPTIONS+=" -DHDF5_ROOT_DIR=$HDF5_ROOT_DIR"
CMAKE_OPTIONS+=" -DMEDFILE_USE_MPI=OFF"
CMAKE_OPTIONS+=" -DMED_MEDINT_TYPE=long"
CMAKE_OPTIONS+=" -DCMAKE_SHARED_LINKER_FLAGS=\"$LDFLAGS\""
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_TESTS=OFF"
CMAKE_OPTIONS+=" $SAT_CMAKE_OPTIONS"

if [ -n "$SAT_HPC" ]; then
    if [ -n "$MPI_ROOT_DIR" ]; then
        CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=$(which mpic++)"
        CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=$(which mpicc)"
    fi
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

sed -i '' 's/typedef long  med_int/typedef int64_t  med_int/g' include/med.h
if [ $? -ne 0 ]; then
    echo "ERROR: could not patch include/med.h"
    exit 1
fi

LC_ALL=C sed -i '' 's/typedef long  med_int/typedef int64_t  med_int/g' include/2.3.6/med.h
if [ $? -ne 0 ]; then
    echo "ERROR: could not patch include/2.3.6/med.h"
    exit 1
fi

#
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
