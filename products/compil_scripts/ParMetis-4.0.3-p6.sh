#!/bin/bash

echo "##########################################################################"
echo "ParMetis" $VERSION
echo "##########################################################################"

cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

echo
echo "*** make config" 
make config \
	cc=${MPI_C_COMPILER} \
	cxx=${MPI_CXX_COMPILER} \
	cflags="-fPIC" \
	prefix=${PRODUCT_INSTALL} \
	metis_path=${METIS_ROOT_DIR} \
	gklib_path=${METIS_ROOT_DIR}/GKlib
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
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
    exit 2
fi

echo
echo "########## END"

