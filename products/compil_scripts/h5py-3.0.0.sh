#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "h5py" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip

mkdir -p $PRODUCT_INSTALL

cd $BUILD_DIR

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH

case $LINUX_DISTRIBUTION in
    CO8)
        WHEELS=('h5py-3.0.0-cp36-cp36m-manylinux1_x86_64.whl')
        ;;
    *)
        echo "Not implemented"
        exit 1
        ;;
esac
for WHEEL in "${WHEELS[@]}"; do
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    if [ $? -ne 0 ]; then
        echo "ERROR: could not install $WHEEL"
        exit 1
    fi
done
if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"
