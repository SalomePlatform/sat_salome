#!/bin/bash

echo "##########################################################################"
echo "PyQt" $VERSION
echo "##########################################################################"



python_name=python$PYTHON_VERSION

echo `env`

echo
echo "*** configure"
python $SOURCE_DIR/configure.py --confirm-license --no-designer-plugin --verbose \
    --bindir=${PRODUCT_INSTALL}/bin \
    --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages \
    --sipdir=${PRODUCT_INSTALL}/sip 2>&1
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi


echo
echo "########## END"

