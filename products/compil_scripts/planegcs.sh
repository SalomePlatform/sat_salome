#!/bin/bash

echo "##########################################################################"
echo "PLANEGCS" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

# Install dir
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=$PRODUCT_INSTALL"

echo
echo "*** cmake " ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS}
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
