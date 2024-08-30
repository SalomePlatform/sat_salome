#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "nose-py3" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo "*** check installation"
mkdir -p ${PRODUCT_INSTALL}
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

INSTALL_CMD="${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --prefix=$PRODUCT_INSTALL"

echo "*** ${INSTALL_CMD}"
if ! ${INSTALL_CMD}; then
    echo "ERROR: ${INSTALL_CMD} failed"
    exit 1
fi

if [ -d ${PRODUCT_INSTALL}/local ];then
    mv ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}
    rm -rf ${PRODUCT_INSTALL}/local
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

echo
echo "########## END"
