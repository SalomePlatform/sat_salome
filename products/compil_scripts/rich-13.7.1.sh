#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "rich" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

if [ ! -d $PRODUCT_INSTALL ]; then
    mkdir -p $PRODUCT_INSTALL
fi

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR

WHEELS=('rich-13.7.1-py3-none-any.whl')
for WHEEL in "${WHEELS[@]}"; do
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    if [ $? -ne 0 ]; then
        echo "ERROR: could not install $WHEEL"
        exit 1
    fi
done
ls -ltr $PRODUCT_INSTALL/
if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
elif [ -d ${PRODUCT_INSTALL}/local ]; then
    mv ${PRODUCT_INSTALL}/local ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"
