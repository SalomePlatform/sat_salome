
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

export QT_API=pyqt5

# create a python virtual env
echo "INFO: $PYTHONBIN -m venv $BUILD_DIR/${PRODUCT_NAME}_venv --system-site-packages"
${PYTHONBIN} -m venv "$BUILD_DIR/${PRODUCT_NAME}_venv" --system-site-packages
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 1
fi

# install dependencies
echo "INFO: source ${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
. "${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 2
fi

echo "INFO: python3 -m pip install meson_python ninja setuptools-scm pybind11 cppy"
python3 -m pip install meson_python ninja setuptools-scm pybind11 cppy
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 3
fi

# install
echo "INFO: running installation command"
echo "python3 -m pip install $SOURCE_DIR --no-binary :all: --no-build-isolation --cache-dir=$BUILD_DIR/cache/pip --prefix=$PRODUCT_INSTALL -vvv"
python3 -m pip install $SOURCE_DIR --no-binary :all: --no-build-isolation --cache-dir=$BUILD_DIR/cache/pip --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
    echo "ERROR: fail to install ${PRODUCT_NAME} with pip"
    exit 4
fi

fix_lib_path

deactivate

echo
echo "########## END"
