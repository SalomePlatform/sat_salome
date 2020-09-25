#!/bin/bash

echo "###############################################"
echo "freeimage" $VERSION
echo "###############################################"
cp -r $SOURCE_DIR/* .



echo
echo "*** FreeImage: make" $MAKE_OPTIONS
make -f Makefile.gnu
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** FreeImage: make install"
make -f Makefile.gnu DESTDIR=$PRODUCT_INSTALL install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** FreeImage: make clean"
make -f Makefile.gnu clean

echo
echo "*** FreeImagePlus: make" $MAKE_OPTIONS
make -f Makefile.fip
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** FreeImagePlus: make install"
make -f Makefile.fip DESTDIR=$PRODUCT_INSTALL install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** FreeImagePlus: make clean"
make -f Makefile.fip clean

echo
echo "########## END"

