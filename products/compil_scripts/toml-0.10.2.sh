#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

echo "$PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip  .  --no-deps --prefix=$PRODUCT_INSTALL"
$PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip  .  --no-deps --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

mkdir -p $PRODUCT_INSTALL/lib/python$PYTHON_VERSION
# ensure that lib is used
if [ -d "$PRODUCT_INSTALL/lib64" ]; then
	echo "WARNING: renaming lib64 directory to lib"
	mv $PRODUCT_INSTALL/lib64/* $PRODUCT_INSTALL/lib/
	rm -rf $PRODUCT_INSTALL/lib64
elif [ -d "$PRODUCT_INSTALL/local/lib64" ]; then
	echo "WARNING: renaming local/lib64 directory to lib"
	mv $PRODUCT_INSTALL/local/lib64/* $PRODUCT_INSTALL/lib
	rm -rf $PRODUCT_INSTALL/local
elif [ -d $PRODUCT_INSTALL/lib ]; then
	:
else
	echo "WARNING: unhandled case! Please ensure that script is consistent!"
fi
