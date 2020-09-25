#!/bin/bash

echo "##########################################################################"
echo "Metis" $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL

cd $SOURCE_DIR

echo
echo "*** make config"
make config prefix=${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on make config"
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
    echo "ERROR on install"
    exit 3
fi

echo
echo "########## END"

