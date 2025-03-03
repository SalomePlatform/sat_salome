#!/bin/bash

echo "##########################################################################"
echo "tk" $VERSION
echo "##########################################################################"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** configure --enable-shared --enable-threads --with-tcl=$TCLHOME/lib --with-tclinclude=$TCLHOME/include"
$SOURCE_DIR/unix/configure --prefix=$TCLHOME --enable-shared --enable-threads \
    --with-tcl=$TCLHOME/lib --with-tclinclude=$TCLHOME/include
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
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
echo "Tk is installed into tcl dir $TCLHOME" > $PRODUCT_INSTALL/README

# Used by NETGEN (TBC -  to be reviewed)
cp tkConfig.sh $TCLHOME/lib

echo
echo "########## END"
