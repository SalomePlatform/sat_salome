#!/bin/bash

echo "##########################################################################"
echo "nlopt" $VERSION
echo "##########################################################################"


#
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

if version_ge $VERSION "2.4.2"; then
    $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --enable-shared --with-python PYTHON=$(which python3) PYTHON_CONFIG=$(which python3-config) CFLAGS='-m64 -fPIC' CPPFLAGS='-m64 -fPIC'
else
    $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --enable-shared --without-octave
fi
echo   "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS"
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

