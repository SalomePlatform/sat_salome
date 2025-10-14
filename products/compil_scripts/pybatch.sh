#!/bin/bash

echo "##########################################################################"
echo "pybatch $VERSION"
echo "##########################################################################"

if [ -d "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"
fi

mkdir -p ${BUILD_DIR}/cache/pip
cd "${BUILD_DIR}"
cp -r "${SOURCE_DIR}"/* .

if [ "${SAT_Python_IS_NATIVE}" != "1" ]; then
    echo
    echo "*** install with $PYTHONBIN -m pip install . --cache-dir=${BUILD_DIR}/cache/pip --no-deps "
    ${PYTHONBIN} -m pip install . --prefix=$PRODUCT_INSTALL --cache-dir=$BUILD_DIR/cache/pip  --no-deps -vvvv
    if [ $? -ne 0 ]; then
        echo "pip install pybatch fails"
        exit 1
    fi
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
