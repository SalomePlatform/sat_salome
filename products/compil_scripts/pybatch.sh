#!/bin/bash

echo "##########################################################################"
echo "pybatch $VERSION"
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

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

PIP_INSTALL_OPTIONS=
PIP_INSTALL_OPTIONS+=" --no-binary :all:"
if [ $LINUX_DISTRIBUTION != "DB11" ]; then
    PIP_INSTALL_OPTIONS+=" --no-build-isolation"
fi
PIP_INSTALL_OPTIONS+=" --prefix=${PRODUCT_INSTALL}"
PIP_INSTALL_OPTIONS+=" -vvv"


echo
echo "INFO: running installation command"
echo "*** ${PYTHONBIN} -m pip install ${SOURCE_DIR}[paramiko] ${PIP_INSTALL_OPTIONS}"
${PYTHONBIN} -m pip install "${SOURCE_DIR}[paramiko]" ${PIP_INSTALL_OPTIONS}
if [ $? -ne 0 ]; then
    echo "pip install pybatch fails"
    exit 4
fi

fix_lib_path

#tests
export PATH=${PRODUCT_INSTALL}/bin:${PATH}
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}

${PYTHONBIN} -m pytest ${SOURCE_DIR}
if [ $? -ne 0 ]; then
    echo "ERROR: pybatch tests fails"
    exit 5
fi

echo
echo "########## END"
