#!/bin/bash

echo "##########################################################################"
echo "OpenMPI" $VERSION
echo "##########################################################################"



# Attention la variable $PYTHOSTARTUP pose problem -> unset.
# Si erreur au make install -> environement "pollué"

echo
echo "*** configure"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
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

