#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "h5py" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
cp -r $SOURCE_DIR $BUILD_DIR
mkdir -p  $BUILD_DIR/cache/pip
cd $BUILD_DIR
$PYTHONBIN setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on ${PYTHONBIN} setup.py  build"
    exit 4
fi
#

$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on ${PYTHONBIN} setup.py  install --prefix=$PRODUCT_INSTALL"
    exit 5
fi
