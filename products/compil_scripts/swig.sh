#!/bin/bash

echo "##########################################################################"
echo "swig" $VERSION
echo "##########################################################################"

# since we are using docker rootless, one has to ensure that some scripts are executable
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** configure --without-pcre --without-octave"
$SOURCE_DIR/configure --prefix=${PRODUCT_INSTALL} --without-pcre --without-octave
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

echo
echo "########## END"

