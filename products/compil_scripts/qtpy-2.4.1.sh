#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "qtpy" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip

mkdir -p $PRODUCT_INSTALL

cd $BUILD_DIR

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH

${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
if [ $? -ne 0 ]; then
    echo "ERROR: could not install"
    exit 1
fi
if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"
