#!/bin/bash

echo "###############################################"
echo "freetype" $VERSION
echo "###############################################"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** configure"
if [[ $BITS == "64" ]]
then
    $SOURCE_DIR/configure CFLAGS="-fPIC -m64" --prefix=$PRODUCT_INSTALL --with-harfbuzz=no
else
    $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL
fi
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

cp $PRODUCT_INSTALL/include/ft2build.h $PRODUCT_INSTALL/include/freetype2 #Fix for ParaView detection of ft2build.h

echo
echo "########## END"

