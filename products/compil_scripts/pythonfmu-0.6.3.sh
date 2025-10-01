#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

fix_lib_path(){
	mkdir -p $PRODUCT_INSTALL/lib/python$PYTHON_VERSION
	# ensure that lib is used
	if [ -d "$PRODUCT_INSTALL/local" ]; then
		cp -r $PRODUCT_INSTALL/local/* $PRODUCT_INSTALL/
		rm -rf $PRODUCT_INSTALL/local
	fi

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

	if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
	    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
	fi
}

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

USE_OLD_SETUPTOOLS=false

if [[ $DIST_NAME == "CO" && "$SAT_Python_IS_NATIVE" == "1" ]]; then
    PRODUCT_LIB=lib64
else
    PRODUCT_LIB=lib
fi

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/${PRODUCT_LIB}/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
    
echo
if [ $USE_OLD_SETUPTOOLS ]; then
    echo "*** install with ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-build-isolation  --prefix=$PRODUCT_INSTALL"
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-build-isolation  --prefix=$PRODUCT_INSTALL -vvv
    if [ $? -ne 0 ]
    then
        echo "ERROR on build"
        exit 1
    fi
else
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
fi

fix_lib_path

echo
echo "########## END"
