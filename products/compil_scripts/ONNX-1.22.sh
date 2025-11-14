#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "ONNX" $VERSION
echo "##########################################################################"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
if [ ! -d ${PRODUCT_INSTALL} ]; then
    mkdir ${PRODUCT_INSTALL}
fi
cd $PRODUCT_INSTALL
cp -r $SOURCE_DIR/* .

# some postbuild fixes
#  https://github.com/microsoft/onnxruntime/issues/25242
#  https://github.com/microsoft/onnxruntime/issues/25279 (lib -> lib64)
cd $PRODUCT_INSTALL

mv lib lib64

mv include include.tmp
mkdir include
mv include.tmp include/onnxruntime

echo
echo "########## END"
