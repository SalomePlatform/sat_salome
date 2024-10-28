#!/bin/bash

echo "##########################################################################"
echo "patsy " $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

USE_OLD_SETUPTOOLS=false

if [[ $DIST_NAME == "CO" && "$SAT_Python_IS_NATIVE" == "1" ]]; then
    PRODUCT_LIB=lib64
else
    PRODUCT_LIB=lib
fi
#mkdir -p $PRODUCT_INSTALL/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
    
echo
if [ $USE_OLD_SETUPTOOLS ]; then
    echo "*** install with ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL"
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL
else
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
