#!/bin/bash

echo "##########################################################################"
echo "trust" $VERSION
echo "##########################################################################"



echo "Install directory :"
echo $PRODUCT_INSTALL
echo "Build directory :"
echo $BUILD_DIR
echo "Source directory :"
echo $SOURCE_DIR

mkdir -p ${PRODUCT_INSTALL}

#cp -rf $BUILD_DIR/TRUST_$VERSION/* $PRODUCT_INSTALL
cp -rf $SOURCE_DIR/* $PRODUCT_INSTALL

#ORG=$PRODUCT_INSTALL"/TRUST_"$VERSION
#cd $ORG
cd $PRODUCT_INSTALL

export LANG=C

#TRUST_VERSION=1.7.3
TRUST_VERSION=$VERSION
export TRUST_VERSION

OPTIONS="-disable-gnuplot -disable-valgrind -without-visit -disable-gmsh -disable-plot2d -disable-checks -disable-check_sources"
#OPTIONS="-disable-optionals"
#OPTIONS="-for_appli_salome"

echo
echo "*** configure"
./configure $OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

source $PRODUCT_INSTALL/env/env_TRUST.sh

MAKE_OPTIONS="optim"

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
