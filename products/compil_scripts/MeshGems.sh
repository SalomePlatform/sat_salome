#!/bin/bash

echo "##########################################################################"
echo "MeshGems" $VERSION
echo "##########################################################################"

echo
echo "*** mkdir" $PRODUCT_INSTALL
mkdir -p $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on mkdir"
    exit 1
fi

echo
echo "*** cp -r "$SOURCE_DIR"/* " $PRODUCT_INSTALL
cp -r $SOURCE_DIR/* $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on cp"
    exit 2
fi

if [ -n "$SAT_HPC" ]
then
    echo "WARNING: adding  MG-Tetra_HPC ..."
    cd $PRODUCT_INSTALL/stubs
    mpicc meshgems_mpi.c -DMESHGEMS_LINUX_BUILD -I ../include -shared -fPIC -o ../lib/Linux_64/libmeshgems_mpi.so
fi

echo
echo "########## END"

