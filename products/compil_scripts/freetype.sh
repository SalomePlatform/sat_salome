#!/bin/bash

echo "###############################################"
echo "freetype" $VERSION
echo "###############################################"

opts=()
if [ "$DIST_NAME" = "macOS" ]; then
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
fi

echo
echo "*** configure --prefix=$PRODUCT_INSTALL --with-harfbuzz=no ${opts[@]}"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --with-harfbuzz=no "${opts[@]}"

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

