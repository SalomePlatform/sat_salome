#!/bin/bash

echo "##########################################################################"
echo "YACSGEN" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo  "*** build in SOURCE directory"
cd $SOURCE_DIR

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
echo "*** $LINUX_DISTRIBUTION *"
case $LINUX_DISTRIBUTION in
    DB12)
        $PYTHONBIN setup.py install --install-lib=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages --install-scripts=${PRODUCT_INSTALL}/bin
        ;;
    UB24*)
        $PYTHONBIN -m pip install . --prefix=$PRODUCT_INSTALL
        ;;
    *)
        $PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
        ;;
esac

if [ $? -ne 0 ]; then
    echo "ERROR on build/install"
    exit 3
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
