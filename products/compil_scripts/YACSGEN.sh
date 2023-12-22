#!/bin/bash

echo "##########################################################################"
echo "YACSGEN" $VERSION
echo "##########################################################################"



echo  "*** build in SOURCE directory"
cd $SOURCE_DIR

# we don't install in python directory -> modify environment as described in INSTALL file
mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
case $LINUX_DISTRIBUTION in
    DB12)
        $PYTHONBIN setup.py install --install-lib=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages --install-scripts=${PRODUCT_INSTALL}/bin
        ;;
    *)
        $PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
        ;;
esac

if [ $? -ne 0 ]; then
    echo "ERROR on build/install"
    exit 3
fi

echo
echo "########## END"
