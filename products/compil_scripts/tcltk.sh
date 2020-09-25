#!/bin/bash

echo "##########################################################################"
echo "tcl/tk" $VERSION
echo "##########################################################################"

echo
echo "INFO: building tcl..."
echo "INFO: running command: configure --enable-shared --enable-threads"

mkdir -p $BUILD_DIR/tcl && cd $BUILD_DIR/tcl
$SOURCE_DIR/tcl/unix/configure --prefix=$PRODUCT_INSTALL --enable-shared --enable-threads
if [ $? -ne 0 ]
then
    echo "ERROR on configure (tcl)"
    exit 1
fi

echo
echo "INFO: running command: make " $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make (tcl)"
    exit 2
fi

echo
echo "INFO: running command: make install (tcl)"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install (tcl)"
    exit 3
fi

echo "INFO: building tk..."
mkdir -p $BUILD_DIR/tk && cd $BUILD_DIR/tk
echo "INFO: running command:  configure --enable-shared --enable-threads --with-tcl=$PRODUCT_INSTALL/lib --with-tclinclude=$PRODUCT_INSTALL/include"
$SOURCE_DIR/tk/unix/configure --prefix=$PRODUCT_INSTALL --enable-shared --enable-threads \
    --with-tcl=$PRODUCT_INSTALL/lib --with-tclinclude=$PRODUCT_INSTALL/include
if [ $? -ne 0 ]
then
    echo "ERROR on configure (tk)"
    exit 2
fi

echo
echo "INFO: running command: make"
make
if [ $? -ne 0 ]
then
    echo "ERROR on make (tk)"
    exit 2
fi

echo
echo "INFO: running command: make install"
make install 
if [ $? -ne 0 ]
then
    echo "ERROR on make install (tk)"
    exit 3
fi

cp tkConfig.sh $PRODUCT_INSTALL/lib # needed by Netgen

echo
echo "########## END"

