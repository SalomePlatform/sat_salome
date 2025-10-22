#!/bin/bash

echo "##########################################################################"
echo "PyQt" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
python_name=python$PYTHON_VERSION

cd $SOURCE_DIR

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

if [ "${SAT_Python_IS_NATIVE}" == "1" ]
then
    # if not set, will try to install in system path...
    mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    export PATH=$(pwd)/bin:$PATH
    export PYTHONPATH=$(pwd):$PYTHONPATH
    export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
fi

CONFIGURE_OPTIONS=
CONFIGURE_OPTIONS+=" --confirm-license"
CONFIGURE_OPTIONS+=" --no-designer-plugin"
CONFIGURE_OPTIONS+=" --verbose"
CONFIGURE_OPTIONS+=" --bindir=${PRODUCT_INSTALL}/bin"
CONFIGURE_OPTIONS+=" --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages"
CONFIGURE_OPTIONS+=" --stubsdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages"
CONFIGURE_OPTIONS+=" --sipdir=${SIP_ROOT_DIR}"
CONFIGURE_OPTIONS+=" --disable=QtNetwork"
CONFIGURE_OPTIONS+=" --disable=QtWebSockets"

case $LINUX_DISTRIBUTION in
    CO10)
        CONFIGURE_OPTIONS+=" --qmake=$(which qmake-qt5)"
        ;;
esac

case $LINUX_DISTRIBUTION in
    CO10|DB13)
        CONFIGURE_OPTIONS+=" --qml-plugindir=${PRODUCT_INSTALL}/lib"
        ;;
esac

echo
echo "*** configure.py $CONFIGURE_OPTIONS"
$PYTHONBIN ./configure.py $CONFIGURE_OPTIONS 2>&1
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]
then
    echo "ERROR on make clean"
    exit 5
fi

# Issue with GUI - TO BE FIXED
if [ -n "$SIP_ROOT_DIR" ]
then
    mkdir -p $PRODUCT_INSTALL/sip
    cp -r $SIP_ROOT_DIR/* $PRODUCT_INSTALL/sip
else
    echo "FATAL: Please set SIP_ROOT_DIR environment variable"
    exit 6
fi

cd $PRODUCT_INSTALL/lib
find . -name "*.so*" |xargs chmod u+rwx

echo
echo "########## END"

exit 0

