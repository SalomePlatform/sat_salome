#!/bin/bash

echo "##########################################################################"
echo "Togl" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* . 
echo
echo "*** configure"
./configure --prefix=${TCLHOME} --with-tcl=${TCLHOME}/lib \
    --with-tk=${TCLHOME}/lib --with-tclinclude=${TCLHOME}/include --with-tkinclude=${TCLHOME}/include
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make"
make
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

mkdir -p $PRODUCT_INSTALL
echo "Togl is installed into tcl dir $TCLHOME" > $PRODUCT_INSTALL/README

echo
echo "########## END"

