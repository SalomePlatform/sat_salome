#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "openturns" $VERSION
echo "##########################################################################"

# we don't install in python directory -> modify environment as described in INSTALL file

#mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
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
