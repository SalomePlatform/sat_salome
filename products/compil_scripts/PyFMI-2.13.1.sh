#!/bin/bash

echo "##########################################################################"
echo "PyFMI " $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

rm -f $BUILD_DIR/src/pyfmi/*.c
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH

case $LINUX_DISTRIBUTION in
    FD40)
        echo
        echo "*** ${PYTHONBIN} -m pip install PyFMI-2.13.0-cp312-cp312-linux_x86_64.whl --prefix=${PRODUCT_INSTALL}"
        ${PYTHONBIN} -m pip install PyFMI-2.13.0-cp312-cp312-linux_x86_64.whl --prefix=${PRODUCT_INSTALL}
        if [ $? -ne 0 ]; then
           echo "Error on pip install"
        fi 
        ;;
    CO10)
        echo
        echo "*** ${PYTHONBIN} -m pip install PyFMI-2.13.0-cp312-cp312-linux_x86_64.whl --prefix=${PRODUCT_INSTALL}"
        ${PYTHONBIN} -m pip install PyFMI-2.13.0-cp312-cp312-linux_x86_64.whl --prefix=${PRODUCT_INSTALL}
        if [ $? -ne 0 ]; then
           echo "Error on pip install"
        fi 
        ;;
    *)
        echo
        echo "*** ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL}"
        ${PYTHONBIN} -m pip install . --no-deps --no-build-isolation --prefix=${PRODUCT_INSTALL} -vvv
        if [ $? -ne 0 ]; then
            echo "Error on pip install"
            exit 1
        fi
        ;;
esac

if [ -d ${PRODUCT_INSTALL}/local ];then
    cp -r ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}/
    rm -rf ${PRODUCT_INSTALL}/local
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mkdir -p ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
    cp -r ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages/* ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/
    rm -rf ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages
fi

if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mkdir -p ${PRODUCT_INSTALL}/lib
    cp -r ${PRODUCT_INSTALL}/lib64/* ${PRODUCT_INSTALL}/lib/
    rm -rf ${PRODUCT_INSTALL}/lib64
fi
echo

echo "########## END"
