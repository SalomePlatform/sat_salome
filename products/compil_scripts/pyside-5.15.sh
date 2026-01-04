#!/bin/bash

echo "##########################################################################"
echo "Pyside" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* $BUILD_DIR

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
case $LINUX_DISTRIBUTION in
    FD42)
        $PYTHONBIN setup.py install --prefix=${PRODUCT_INSTALL}  --parallel=$(nproc) --build-tests --skip-docs --qmake=$(which qmake-qt5)
        ;;
    *)
        $PYTHONBIN setup.py install --prefix=${PRODUCT_INSTALL}  --parallel=$(nproc) --build-tests --skip-docs --qmake=$(which qmake)
        ;;
esac
if [ $? -ne 0 ]; then
    echo "ERROR on build"
    exit 1
fi

echo "*** check path"
if [ -d "${PRODUCT_INSTALL}/local" ]; then
    mv ${PRODUCT_INSTALL}/local/* ${PRODUCT_INSTALL}/
    rm -rf ${PRODUCT_INSTALL}/local
fi

# occurs on FD42 -  need to figure out where it is set
if [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    mv ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

if [ "${SAT_qt_IS_NATIVE}" == "1" ]; then
    cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/PySide2
    if [ "$LINUX_DISTRIBUTION" == "FD42" ]; then
        ln -sf /usr/bin/uic-qt5 uic
        ln -sf /usr/bin/rcc-qt5 rcc
        ln -sf /usr/bin/uic-qt5
        ln -sf /usr/bin/rcc-qt5
    else
        ln -sf $(which qtchooser) uic
        ln -sf $(which qtchooser) rcc
    fi
fi

cp ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/PySide2/examples/utils/pyside2_config.py ${PRODUCT_INSTALL}/bin/pyside2_config.py
if [ $? -ne 0 ]; then
    echo "FATAL: could not copy pyside2_config.py"
    exit 1
fi

chmod 755 ${PRODUCT_INSTALL}/bin/pyside2_config.py

echo
echo "########## END"

exit 0
