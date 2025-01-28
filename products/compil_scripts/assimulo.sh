#!/bin/bash

echo "##########################################################################"
echo Assimulo $VERSION
echo "##########################################################################"

cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

echo 
echo "*** ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL}"
if ! ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} -vvv; then
    echo "Error on pip install"
    exit 1
fi

if [ -d ${PRODUCT_INSTALL}/local ];then
    mv ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}
    rm -rf ${PRODUCT_INSTALL}/local
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"
