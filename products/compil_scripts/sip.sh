#!/bin/bash

echo "##########################################################################"
echo "sip" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

python_name=python$PYTHON_VERSION

echo
echo "*** configure.py -b ${PRODUCT_INSTALL}/bin -d ${PRODUCT_INSTALL}/lib/${python_name}/site-packages -e ${PRODUCT_INSTALL}/include/${python_name} -v ${PRODUCT_INSTALL}/sip"
python ./configure.py -b ${PRODUCT_INSTALL}/bin \
    -d ${PRODUCT_INSTALL}/lib/${python_name}/site-packages \
    -e ${PRODUCT_INSTALL}/include/${python_name} \
    -v ${PRODUCT_INSTALL}/sip

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

