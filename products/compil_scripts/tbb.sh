#!/bin/bash

echo "##########################################################################"
echo "tbb" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cp -r $SOURCE_DIR/* $BUILD_DIR/


echo
echo "*** make"
make 
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

rm -rf $PRODUCT_INSTALL
mkdir -p $PRODUCT_INSTALL
cp -r $BUILD_DIR/include $PRODUCT_INSTALL/include
cp -r $BUILD_DIR/build/linux*_release $PRODUCT_INSTALL/lib

cd $PRODUCT_INSTALL/lib
find . -name "*.so*" |xargs chmod u+rwx 

echo
echo "########## END"
