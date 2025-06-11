#!/bin/bash

echo "##########################################################################"
echo "C3PO $VERSION"
echo "##########################################################################"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** install with ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --cache-dir=${BUILD_DIR}/cache/pip"
if ! ${PYTHONBIN} -m pip install . --prefix="${PRODUCT_INSTALL}" --cache-dir="${BUILD_DIR}/cache/pip"; then
    echo "pip install C3PO fails"
    exit 2
fi

PYTEST=$(which pytest)

if [ -d ${PRODUCT_INSTALL}/local ];then
    mv ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}
    rm -rf ${PRODUCT_INSTALL}/local
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

if [ -n $PYTEST ]; then
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
else
    echo
    echo "WARNING: pytest not found. C3PO non-regression tests skipped."
fi

echo
echo "########## END"
