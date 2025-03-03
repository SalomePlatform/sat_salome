#!/bin/bash

echo "##########################################################################"
echo "cppunit" $VERSION
echo "##########################################################################"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

# compilation
echo "cppunit compilation"

echo
echo '*** configure --enable-static LDFLAGS="-ldl"'
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --enable-static LDFLAGS="-ldl"
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

