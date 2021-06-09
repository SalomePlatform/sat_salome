#!/bin/bash
echo "##########################################################################"
echo "cgnslib" $VERSION
echo "##########################################################################"



# compilation
echo "cgnslib compilation"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"

#add hdf5 support (tuleap spns #8161)
CMAKE_OPTIONS+=" -DCGNS_ENABLE_HDF5:BOOL=ON"

if [ -n "$SAT_HPC" ]
then
    echo "HPC mode, activate -DHDF5_NEEDS_MPI:BOOL=ON option"
    CMAKE_OPTIONS+=" -DHDF5_NEEDS_MPI:BOOL=ON"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpic++"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpicc"
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
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

