#!/bin/bash

echo "##########################################################################"
echo "tbb" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .
chmod +x $BUILD_DIR/build/build.py
echo **** $PYTHON_BIN $BUILD_DIR/build/build.py --install --install-python --prefix=$PRODUCT_INSTALL
$PYTHON_BIN $BUILD_DIR/build/build.py --install --install-python --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 1
fi
echo
echo "########## END"
