
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

cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

echo "INFO: running installation command"
echo "${PYTHONBIN} -m pip install . --no-binary :all: --no-build-isolation --cache-dir=$BUILD_DIR/cache/pip --prefix=$PRODUCT_INSTALL -vvv"
if  ! ${PYTHONBIN} -m pip install . --no-binary :all: --no-build-isolation --cache-dir=$BUILD_DIR/cache/pip --prefix=$PRODUCT_INSTALL -vvv; then
    echo "ERROR: fail to install ${PRODUCT_NAME} with pip"
    exit 1
fi

fix_lib_path

echo
echo "########## END"
