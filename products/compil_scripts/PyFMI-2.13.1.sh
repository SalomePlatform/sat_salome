#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "PyFMI " $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

rm -f $BUILD_DIR/src/pyfmi/*.c
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH

echo 
echo "*** ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL}"
if ! ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} -vvv; then
    echo "Error on pip install"
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
