#!/bin/bash

echo "##########################################################################"
echo "cork" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 1
fi

echo
echo "*** make install"
mkdir -p ${PRODUCT_INSTALL}/bin
for f in $(ls $BUILD_DIR/bin); do
    echo "INFO: next file: $f"
    F=${PRODUCT_INSTALL}/bin/$(basename $f)
    mv $BUILD_DIR/bin/$f $F
    if [ $? -ne 0 ]; then
        echo "ERROR on make install for file: $f"
        exit 2
    fi
    if [ ! -L "$F" ]; then
        chmod 755 $F
    fi
done

cd $PRODUCT_INSTALL/bin
mv cork cork_bin
if [ $? -ne 0 ]; then
    echo "ERROR on make install for file: $f"
    exit 3
fi

cp -r ${BUILD_DIR}/include ${PRODUCT_INSTALL}/include
if [ $? -ne 0 ]; then
    echo "ERROR on make install: could not copy include directory..."
    exit 4
fi

echo
echo "########## END"
