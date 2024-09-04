#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "BasicIterativeStatistics" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo $PYTHONPATH|tr ':' '\n'|grep -E 'poetry|pyyaml'
mkdir -p ${PRODUCT_INSTALL}

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

echo 

echo "*** ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL}"
${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps --prefix=$PRODUCT_INSTALL --no-build-isolation
if [ $? -ne 0 ] ; then
    echo "Error on pip install"
    exit 1
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
