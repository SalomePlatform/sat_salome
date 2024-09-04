#!/bin/bash

echo "##########################################################################"
echo "pytest $VERSION"
echo "##########################################################################"

rm -rf "${BUILD_DIR}"
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}" || { echo "cd ${BUILD_DIR} fails"; exit 1; }
cp -r "${SOURCE_DIR}"/* .


if [ "${SAT_Python_IS_NATIVE}" == "1" ]; then
    PYTEST=$(which pytest)
fi

if [ "${SAT_Python_IS_NATIVE}" != "1" ] || [ -z "${PYTEST}" ]; then
    echo
    echo "*** install with $PYTHONBIN -m pip install . --cache-dir=${BUILD_DIR}/cache/pip"
    ${PYTHONBIN} -m pip install . --prefix=$PRODUCT_INSTALL --cache-dir=$BUILD_DIR/cache/pip -vvv 
    if [ $? -ne 0 ]; then
        echo "pip install pytest fails"
        echo 3
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
