#!/bin/bash

echo "##########################################################################"
echo "Scotch" $VERSION
echo "##########################################################################"



mkdir -p $PRODUCT_INSTALL

cp -r $SOURCE_DIR/* .

echo
echo "*** copy BUILD to INSTALL"
cp -ar ${PRODUCT_BUILD}/* ${PRODUCT_INSTALL}
cd ${PRODUCT_INSTALL}/src

echo
echo "*** create Makefile"
if [[ $VERSION == "6.0.4" ]]
then
    sed -e "s%CFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%CFLAGS\1=\2-fPIC \3%g" Make.inc/Makefile.inc.x86-64_pc_linux2 > Makefile.inc
fi
if [[ $BITS == "64" ]]
then
    if [[ $VERSION == "5.1.11" ]]
    then
        sed -e "s%CFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%CFLAGS\1=\2-fPIC \3%g" Makefile.inc > Makefile.in_new
        cp Makefile.in_new Makefile.inc
    else
        sed -e 's|CFLAGS\t=|& -fPIC|g' Makefile.inc > Makefile.in_new
        cp Makefile.in_new Makefile.inc
    fi
fi

# add pthread for gcc > 4.4
sed -e "s%LDFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%LDFLAGS\1=\2 \3 -lpthread%g" Makefile.inc > Makefile.in_new
cp Makefile.in_new Makefile.inc


echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "########## END"

