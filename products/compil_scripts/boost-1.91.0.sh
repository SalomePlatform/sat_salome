#!/bin/bash

echo "##########################################################################"
echo "BOOST" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd  $BUILD_DIR
cp -r $SOURCE_DIR/* .

echo
echo "*** bootstrap.sh"
./bootstrap.sh --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on bootstrap"
    exit 1
fi

echo "*** b2 cxxflags="-std=c++14" ${MAKE_OPTIONS} install"

./b2 cxxflags="-std=c++14" ${MAKE_OPTIONS} install

if [ $? -ne 0 ]
then
    echo "ERROR on b2 install"
    exit 3
fi

echo
echo "########## END"
