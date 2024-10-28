#!/bin/bash

echo "##########################################################################"
echo "statsmodels " $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

USE_OLD_SETUPTOOLS=false

echo
if [ $USE_OLD_SETUPTOOLS ]; then
    echo "*** install with ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL"
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL
else
    mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    
    echo "*** build with $PYTHONBIN"
    $PYTHONBIN setup.py build
    if [ $? -ne 0 ]
    then
        echo "ERROR on build"
        exit 2
    fi

    echo
    echo "*** install with $PYTHONBIN"
    $PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
    if [ $? -ne 0 ]
    then
        echo "ERROR on install"
        exit 3
    fi
fi

if [ -d "${PRODUCT_INSTALL}/lib64" ]; then
    echo "WARNING: moving lib64 to lib"
    mv $PRODUCT_INSTALL/lib64 $PRODUCT_INSTALL/lib
elif [ -d "${PRODUCT_INSTALL}/local/lib64" ]; then
    echo "WARNING: moving local/lib64 to lib"
    mv $PRODUCT_INSTALL/local/lib64 $PRODUCT_INSTALL/lib
    rm -rf ${PRODUCT_INSTALL}/local/lib64
fi

echo
echo "########## END"
