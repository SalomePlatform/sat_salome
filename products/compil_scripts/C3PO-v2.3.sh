#!/bin/bash

echo "##########################################################################"
echo "C3PO $VERSION"
echo "##########################################################################"

rm -rf "${BUILD_DIR}"
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}" || { echo "cd ${BUILD_DIR} fails"; exit 1; }
cp -r "${SOURCE_DIR}"/* .

echo
echo "*** install with ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --cache-dir=${BUILD_DIR}/cache/pip"
if ! ${PYTHONBIN} -m pip install . --prefix="${PRODUCT_INSTALL}" --cache-dir="${BUILD_DIR}/cache/pip"; then
    echo "pip install C3PO fails"
    exit 2
fi

if [ "${SAT_Python_IS_NATIVE}" == "1" ] && [ "$PYTEST_ROOT_DIR" != "" ]; then
    PYTEST=$(which pytest)
fi

if [ "${SAT_Python_IS_NATIVE}" != "1" ] || [ -z "${PYTEST}" ]; then
    echo
    echo "*** install with $PYTHONBIN -m pip install ${BUILD_DIR}/ext/pytest-8.1.1.tar.gz --cache-dir=${BUILD_DIR}/cache/pip"
    if ! ${PYTHONBIN} -m pip install "${BUILD_DIR}/ext/pytest-8.1.1.tar.gz" --prefix="${PRODUCT_INSTALL}" --cache-dir="${BUILD_DIR}/cache/pip"; then
        echo "pip install pytest fails"
        echo 3
    fi
    export PATH="${PRODUCT_INSTALL}/bin":$PATH
fi

if [ -d ${PRODUCT_INSTALL}/local ];then
    mv ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}
    rm -rf ${PRODUCT_INSTALL}/local
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

echo
echo "*** running C3PO non-regression tests"
export LD_LIBRARY_PATH="${MEDCOUPLING_ROOT_DIR}/lib:${LD_LIBRARY_PATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/${PYTHON_LIBDIR}:${PYTHONPATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/lib:${PYTHONPATH}"
export PYTHONPATH="${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}"

if ! "${BUILD_DIR}"/run_tests.sh; then
    echo "C3PO non-regression tests fails"
    exit 3
fi

echo
echo "########## END"
