#!/bin/bash

#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "statsmodels " $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"


cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

if [[ $DIST_NAME == "CO" && $DIST_VERSION == "8" && $APPLICATION_NAME =~ native ]]; then
    PRODUCT_LIB=lib64
else
    PRODUCT_LIB=lib
fi
mkdir -p $PRODUCT_INSTALL/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
    
echo
echo "*** build with $PYTHONBIN"
###$PYTHONBIN setup.py clean
$PYTHONBIN setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

echo
echo "*** install with $PYTHONBIN"
$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

echo
echo "########## END"
