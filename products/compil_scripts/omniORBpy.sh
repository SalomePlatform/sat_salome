#!/bin/bash

echo "##########################################################################"
echo "omniORBpy" $VERSION
echo "##########################################################################"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

opts=()
if [ "$DIST_NAME" = "macOS" ]; then
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
fi

echo
echo "*** configure  --prefix=${OMNIORB_ROOT_DIR} ${opts[@]}"
PYTHON=$PYTHONBIN $SOURCE_DIR/configure --prefix=${OMNIORB_ROOT_DIR} "${opts[@]}"
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

mkdir -p $PRODUCT_INSTALL
echo "omniORBpy is installed into omni dir ${OMNIORB_ROOT_DIR}" > $PRODUCT_INSTALL/README

# fix
if [ -d $OMNIORB_ROOT_DIR/local ]; then
    mv $OMNIORB_ROOT_DIR/local/lib/* $OMNIORB_ROOT_DIR/lib
    rm -rf $OMNIORB_ROOT_DIR/local
fi

if [ -d $OMNIORB_ROOT_DIR/lib/python${PYTHON_VERSION}/dist-packages ]; then
   mv $OMNIORB_ROOT_DIR/lib/python${PYTHON_VERSION}/dist-packages $OMNIORB_ROOT_DIR/lib/python${PYTHON_VERSION}/site-packages
fi

cd $OMNIORB_ROOT_DIR/lib

if [ $DIST_NAME = "macOS" ]; then
    find . -name "*.dylib*" |xargs chmod u+rwx 
else
    find . -name "*.so*" |xargs chmod u+rwx 
fi

if [ "${OMNIORBPY_REMOVE_INIT}" == "1" ]; then
    sed -i '2491,2496 d' $OMNIORB_ROOT_DIR/lib/python${PYTHON_VERSION}/site-packages/omniidl_be/python.py
fi

echo
echo "########## END"
