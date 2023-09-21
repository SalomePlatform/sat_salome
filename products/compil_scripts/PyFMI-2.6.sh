#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "PyFMI " $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"


cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

rm -f $BUILD_DIR/src/pyfmi/*.c
#mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
#export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build with $PYTHONBIN"
$PYTHONBIN setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

echo
echo "*** install with $PYTHONBIN"
$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL --fmil-home=$FMIL_HOME
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

# ensure that lib is used
if [ -d "$PRODUCT_INSTALL/lib64" ]; then
    echo "WARNING: renaming lib64 directory to lib"
    mv $PRODUCT_INSTALL/lib64 $PRODUCT_INSTALL/lib
elif [ -d "$PRODUCT_INSTALL/local/lib64" ]; then
    echo "WARNING: renaming local/lib64 directory to lib"
    mv $PRODUCT_INSTALL/local/lib64 $PRODUCT_INSTALL/lib
    rm -rf $PRODUCT_INSTALL/local
fi

echo
echo "########## END"
