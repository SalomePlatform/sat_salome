#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "h5py" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
cp -r $SOURCE_DIR $BUILD_DIR

mkdir -p ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}
mkdir -p $PRODUCT_INSTALL
echo

cd $BUILD_DIR

echo "*** setup.py BUILD"
python setup.py build

echo "*** setup.py INSTALL"
python setup.py install --prefix=${PRODUCT_INSTALL} --install-lib ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
if [ $? -ne 0 ]; then
    echo "ERROR on setup"
    exit 3
fi

echo
echo "########## END"

