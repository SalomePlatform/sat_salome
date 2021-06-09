#!/bin/bash

echo "##########################################################################"
echo "med" $VERSION
echo "##########################################################################"



CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_STATIC_LIBS:BOOL=OFF"
CMAKE_OPTIONS+=" -DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DHDF5_ROOT_DIR:STRING=${HDF5_ROOT_DIR}"

if [ -n "$SAT_HPC" ]
then
    CMAKE_OPTIONS+=" -DMEDFILE_USE_MPI:BOOL=ON"
else
    CMAKE_OPTIONS+=" -DMEDFILE_USE_MPI:BOOL=OFF"
fi

# OP 20/04/2017 TEST pour overwrite compilateur Fortran sur CO6 avec cmake
preCMake=""
lsb_release -a > /dev/null
if [ $? -eq 0 ]
then
# commande connue donc on peut l'utiliser pour recuperer l'OS
    OSDesc=`lsb_release -a | grep -i description`
    COFound=`echo $OSDesc | grep CentOS`
    R6Found=`echo $OSDesc | grep '6\.'`
    if [ -n "$COFound" -a -n "$R6Found" ]
    then
        #echo "Compilation on CentOS 6 !!!"
        preCMake="FC=`which gfortran` F77=`which gfortran`"
    fi
fi

echo "*** cmake" $CMAKE_OPTIONS
#cmake $CMAKE_OPTIONS $SOURCE_DIR
#echo "$preCMake cmake $CMAKE_OPTIONS $SOURCE_DIR"
eval $preCMake cmake $CMAKE_OPTIONS $SOURCE_DIR

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
echo "########## END"

