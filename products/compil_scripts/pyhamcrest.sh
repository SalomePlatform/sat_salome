#!/bin/bash

echo "##########################################################################"
echo "pyhamcrest" $VERSION
echo "##########################################################################"



echo  "*** build in SOURCE directory"
cd $SOURCE_DIR
PRODUCT_NAME=`ls *.whl` 

echo ##########################################################################
echo *** Installing $PRODUCT_NAME version: $VERSION
echo ##########################################################################

rm -rf $PRODUCT_INSTALL && mkdir -p $PRODUCT_INSTALL
$PYTHONBIN -m pip install --no-dependencies $PRODUCT_NAME
if [ $? -ne 0 ]
then
    echo "ERROR on build/install"
    exit 3
fi

echo
echo "########## END"

