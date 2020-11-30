#!/bin/bash

echo "##########################################################################"
echo "PyQtChart " $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL 
cd $PRODUCT_INSTALL
echo "PyQtChart  will be installed in PyQt folder..." >> README

python_name=python$PYTHON_VERSION

echo `env`

echo

cp -f $SOURCE_DIR/PyQt5/QtChart.so ${PYQT5_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/PyQt5/QtChart.so
if [ $? -ne 0 ]
then
    echo "ERROR: could not copy QtCharts.so"
    exit 1
fi

# useless -  use the Qt one
rm -rf ${PYQT5_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/PyQt5/Qt
cp -r $SOURCE_DIR/PyQt5/Qt ${PYQT5_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/PyQt5/Qt
if [ $? -ne 0 ]
then
    echo "ERROR: could not copy Qt"
    exit 2
fi

rm -f ${PYQT5_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/PyQt5/Qt/lib/libQt5Charts.so.5
if [ $? -ne 0 ]
then
    echo "ERROR: could not remove Qt/libQt5Charts.so.5"
    exit 3
fi

echo
echo "########## END"

