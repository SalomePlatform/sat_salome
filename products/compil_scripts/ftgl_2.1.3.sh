#!/bin/bash

echo "###############################################"
echo "ftgl" $VERSION
echo "###############################################"


cp -r $SOURCE_DIR/* .



./autogen.sh

echo
echo "*** configure"
./configure --prefix=$PRODUCT_INSTALL --enable-shared=yes \
    --with-ft-prefix=$FREETYPEDIR \
    --with-gl-inc="-lm" 
#    --disable-doc
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

export ECHO=echo

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
    rm -Rf $PRODUCT_INSTALL
    exit 3
fi

echo
echo "########## END"

