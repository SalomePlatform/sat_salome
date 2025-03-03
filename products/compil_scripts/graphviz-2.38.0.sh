#!/bin/bash

echo "##########################################################################"
echo "graphviz" $VERSION
echo "##########################################################################"



mkdir -p $PRODUCT_INSTALL

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* . 

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

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

# 23/03/2022
# feedback sent by Vadim SANDERS
# cannot run 'dot -c': failed to open /usr/lib/graphviz/config6a for write
# strangely on some Debian 9, the dot command triggers
export PATH=${PRODUCT_INSTALL}/bin:${PATH}
export LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib:${PRODUCT_INSTALL}/lib/graphviz:${LD_LIBRARY_PATH}
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

