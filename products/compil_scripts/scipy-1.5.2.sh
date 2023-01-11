#!/bin/bash

echo "##########################################################################"
echo "scipy" $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

SCIPY_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${SCIPY_INSTALL}

PYTHONPATH=${SCIPY_INSTALL}:$PWD:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on build/install"
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

cd  $SCIPY_INSTALL
f=$(find . -type d -name "scipy-$VERSION-py${PYTHON_VERSION}-*x86_64.egg")
if [ $? -eq 0 ]; then
    EGG_DIR=$(ls |grep scipy-$VERSION-py${PYTHON_VERSION} |grep x86_64.egg)
    echo "INFO:  Found $EGG_DIR"
    if [ -d $EGG_DIR/scipy ]; then
	ln -sf $EGG_DIR/scipy
    else
	echo "WARNING: could not find $EGG_DIR/scipy"
    fi
else
    echo "WARNING: could not find egg directory with name: scipy-$VERSION-py${PYTHON_VERSION}-*-x86_64.egg"
fi

echo
echo "########## END"
