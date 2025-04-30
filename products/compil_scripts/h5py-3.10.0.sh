#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "h5py" $VERSION
echo "##########################################################################"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

echo "*** ${PYTHONBIN} -m pip install . --cache-dir=${BUILD_DIR}/cache/pip --prefix=${PRODUCT_INSTALL}"
if ! ${PYTHONBIN} -m pip install . --cache-dir="${BUILD_DIR}/cache/pip" --prefix="${PRODUCT_INSTALL}"; then
    echo "pip install ${PRODUCT_NAME} fails"
    exit 1
fi

if [ -d ${PRODUCT_INSTALL}/lib64 ];then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

echo
echo "########## END"

