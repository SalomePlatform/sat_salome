#!/bin/bash

echo "##########################################################################"
echo "graphviz" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* . 

echo "graphviz compilation"

echo
echo "*** configure --prefix=${PRODUCT_INSTALL}  --enable-tcl=no --with-expat=no --with-qt=no  --enable-perl=no --enable-ocaml=no"
./configure --prefix=${PRODUCT_INSTALL} --enable-tcl=no --with-expat=no --with-qt=no  --enable-perl=no --enable-ocaml=no --with-ghostscript=no --enable-python=no --enable-java=no

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" ${MAKE_OPTIONS}
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

