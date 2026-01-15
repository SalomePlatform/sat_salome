#!/bin/bash

echo "##########################################################################"
echo "pybatch $VERSION"
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

if [ -d "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"
fi
mkdir $BUILD_DIR
mkdir -p ${BUILD_DIR}/cache/pip
cd "${BUILD_DIR}"

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_CACHE_DIR=${BUILD_DIR}/cache/pip

echo
echo "INFO: running installation command"
echo "*** ${PYTHONBIN} -m pip install ${SOURCE_DIR}[paramiko] --no-binary :all: --no-build-isolation --prefix=${PRODUCT_INSTALL} -vvv"
${PYTHONBIN} -m pip install "${SOURCE_DIR}[paramiko]" --no-binary :all: --no-build-isolation --prefix="${PRODUCT_INSTALL}" -vvv
if [ $? -ne 0 ]; then
    echo "pip install pybatch fails"
    exit 4
fi
fix_lib_path

echo
echo "########## END"
