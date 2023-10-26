#!/bin/bash

echo "##########################################################################"
echo "pandas " $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"

cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH

echo
echo "*** install with $PYTHONBIN"
$PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip  .  --no-deps --prefix=$PRODUCT_INSTALL 
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

# ensure that lib is used
if [ -d "$PRODUCT_INSTALL/lib64" ]; then
    echo "WARNING: renaming lib64 directory to lib"
    mv $PRODUCT_INSTALL/lib64 $PRODUCT_INSTALL/lib
elif [ -d "$PRODUCT_INSTALL/local/lib64" ]; then
    echo "WARNING: renaming local/lib64 directory to lib"
    mv $PRODUCT_INSTALL/local/lib64 $PRODUCT_INSTALL/lib
    rm -rf $PRODUCT_INSTALL/local
fi

echo
echo "########## END"
