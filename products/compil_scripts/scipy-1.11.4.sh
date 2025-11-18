#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

rm -f site.cfg

if [ "$SAT_openblas_IS_NATIVE" != "1" ]; then
    {
        echo "[DEFAULT]"
        echo "library_dirs = ${OPENBLASHOME}/lib"
        echo "include_dirs = ${OPENBLASHOME}/include"
        echo
        echo "[blas]"
        echo "libraries = openblas"
        echo
        echo "[lapack]"
        echo "libraries = openblas"
        echo
        echo "[numpy]"
        echo "include_dirs = ${NUMPY_INCLUDE_DIR2}"
    } > site.cfg
fi

if [[ $DIST_NAME == "CO" && "$SAT_Python_IS_NATIVE" == "1" ]]; then
    PRODUCT_LIB=lib64
else
    PRODUCT_LIB=lib
fi

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

cd $BUILD_DIR
echo
echo "*** install with ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-build-isolation --prefix=$PRODUCT_INSTALL"
${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-binary :all: --no-build-isolation --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
  echo "ERROR on install"
  exit 3
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
