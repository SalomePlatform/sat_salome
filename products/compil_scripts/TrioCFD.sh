#!/bin/bash

echo "##########################################################################"
echo "triocfd" $VERSION
echo "##########################################################################"



echo "Install directory :"
echo $PRODUCT_INSTALL
echo "Build directory :"
echo $BUILD_DIR
echo "Source directory :"
echo $SOURCE_DIR
echo "TRUST directory :"
echo $TRUST_ROOT_DIR

mkdir -p ${PRODUCT_INSTALL}

#cp -rf $BUILD_DIR/TrioCFD/* $PRODUCT_INSTALL
cp -rf $SOURCE_DIR/* $PRODUCT_INSTALL

TRUST_ROOT=$TRUST_ROOT_DIR

#ORG=$PRODUCT_INSTALL"/TrioCFD"
#cd $ORG
cd $PRODUCT_INSTALL

export LANG=C

#TRUST_VERSION=1.7.2
TRUST_VERSION=$VERSION
export TRUST_VERSION

source $TRUST_ROOT_DIR/env/env_TRUST.sh

OPTIONS=""

echo
echo "*** configure"
baltik_build_configure
./configure  $OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

MAKE_OPTIONS="optim debug"

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
