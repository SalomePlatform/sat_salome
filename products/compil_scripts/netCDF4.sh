#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

USE_OLD_SETUPTOOLS=true

if [[ "$DIST_NAME" == "CO" && "$SAT_Python_IS_NATIVE" == "1" ]]; then
    PRODUCT_LIB=lib64
else
    PRODUCT_LIB=lib
fi

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

if [ -n "$SAT_HPC" ]  && [ -n "$MPI_ROOT_DIR" ]; then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CXX="${MPI_CXX_COMPILER}"
    export CC="${MPI_C_COMPILER}"
fi

echo
if $USE_OLD_SETUPTOOLS; then
    echo "*** install with ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-build-isolation  --prefix=$PRODUCT_INSTALL"
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-build-isolation  --prefix=$PRODUCT_INSTALL -vvv
    if [ $? -ne 0 ]
    then
        echo "ERROR on build"
        exit 1
    fi
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

if [ ! -d "${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/netCDF4" ] && [ -d "${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/netCDF4-1.6.5-py${PYTHON_VERSION}-linux-x86_64.egg/netCDF4" ]; then
    echo "WARNING: rearrange site-packages/netCDF4"
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/netCDF4-1.6.5-py${PYTHON_VERSION}-linux-x86_64.egg/netCDF4 ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

echo
echo "########## END"
