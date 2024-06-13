#!/bin/bash

echo "##########################################################################"
echo SIP + PyQt5_sip $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/sip-5.5.0 $BUILD_DIR/sip-5.5.0
cd $BUILD_DIR/sip-5.5.0

USE_SETUP=false
if [[ "$PYTHON_VERSION" == "3.6" ]]; then
    USE_SETUP=true
fi

case $LINUX_DISTRIBUTION in
    CO9)
        USE_SETUP=false
        ;;
    *)
        ;;
esac

# we don't install in python directory -> modify environment as described in INSTALL file
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
if [ "$USE_SETUP" == "true" ]; then
    mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
    echo
    echo "*** build with $PYTHONBIN"
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
else
    $PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip  .  --no-deps --prefix=$PRODUCT_INSTALL
    if [ $? -ne 0 ]
    then
        echo "ERROR on install"
        exit 3
    fi
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

cd $BUILD_DIR
cp -R $SOURCE_DIR/PyQt5_sip-12.8.1 $BUILD_DIR/PyQt5_sip-12.8.1
cd $BUILD_DIR/PyQt5_sip-12.8.1

echo
echo "*** build with $PYTHONBIN"
if [ "$USE_SETUP" == "true" ]; then
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
else
    echo
    echo "*** install with $PYTHONBIN"
    $PYTHONBIN -m pip install --cache-dir=$BUILD_DIR/cache/pip  .  --no-deps --prefix=$PRODUCT_INSTALL
    if [ $? -ne 0 ]
    then
        echo "ERROR on install"
        exit 3
    fi
fi

# ensure that lib is used
if [ -d "$PRODUCT_INSTALL/lib64" ]; then
	echo "WARNING: renaming lib64 directory to lib"
	cp -r $PRODUCT_INSTALL/lib64/* $PRODUCT_INSTALL/lib
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

mkdir $PRODUCT_INSTALL/include
cp *.h $PRODUCT_INSTALL/include

cd $PRODUCT_INSTALL/bin
ln -sf sip5 sip

case $LINUX_DISTRIBUTION in
    DB10)
        cd $PRODUCT_INSTALL/lib/python3.7/site-packages
        ln -sf PyQt5_sip-12.8.1-py3.7-linux-x86_64.egg/PyQt5
        ;;
    *)
        ;;
esac

echo
echo "########## END"
