#!/bin/bash

echo "##########################################################################"
echo "distribute" $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL
echo

cd $SOURCE_DIR

# Making a directory that will be used in install
mkdir -p ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo "*** setup.py BUILD"
python $SOURCE_DIR/setup.py build
echo

echo "*** setup.py INSTALL"
python $SOURCE_DIR/setup.py install --prefix=${PRODUCT_INSTALL}

if [ $? -ne 0 ]
then
    echo "ERROR on setup"
    exit 3
fi

echo
echo "########## END"

