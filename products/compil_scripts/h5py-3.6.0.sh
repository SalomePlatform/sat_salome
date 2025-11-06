#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "h5py" $VERSION
echo "##########################################################################"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

H5PY_SETUP_REQUIRES=0
${PYTHONBIN} ./setup.py build

echo "*** ${PYTHONBIN} -m pip install . --no-build-isolation --cache-dir=${BUILD_DIR}/cache/pip --prefix=${PRODUCT_INSTALL}"
pip install . --no-build-isolation --cache-dir="${BUILD_DIR}/cache/pip" --prefix="${PRODUCT_INSTALL}"
if [ $? -ne 0 ]; then
    echo "pip install ${PRODUCT_NAME} fails"
    exit 1
fi

# ensure that lib is used
if [ -d "$PRODUCT_INSTALL/local" ]; then
    cp -r $PRODUCT_INSTALL/local/* $PRODUCT_INSTALL/
    rm -rf $PRODUCT_INSTALL/local
fi

if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

echo
echo "########## END"

