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

# create a python virtual env
echo
echo "INFO: ${PYTHONBIN} -m venv ${BUILD_DIR}/${PRODUCT_NAME}_venv --system-site-packages"
${PYTHONBIN} -m venv ${BUILD_DIR}/${PRODUCT_NAME}_venv --system-site-packages
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 1
fi

#install build dependencies
echo
echo "INFO: . ${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
. "${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 2
fi

echo "INFO: python3 -m pip install"
#python3 -m pip install --upgrade pip
#python3 -m pip install
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 3
fi

#install
echo
echo "INFO: running installation command"
echo "*** python3 -m pip install ${SOURCE_DIR}[paramiko,test] --no-binary :all: --cache-dir=${BUILD_DIR}/cache/pip --prefix=${PRODUCT_INSTALL} -vvv"
python3 -m pip install "${SOURCE_DIR}[paramiko,test]" --no-binary :all: --cache-dir="${BUILD_DIR}/cache/pip" --prefix="${PRODUCT_INSTALL}" -vvv #--no-build-isolation
if [ $? -ne 0 ]; then
    echo "pip install pybatch fails"
    exit 4
fi
fix_lib_path

#tests
export PATH=${PRODUCT_INSTALL}/bin:${PATH}
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}

if [ -f "${SOURCE_DIR}/conftest.py" ]; then
    cp "${SOURCE_DIR}/conftest.py" "${PRODUCT_INSTALL}/conftest.py"
fi

if [ -f "${SOURCE_DIR}/tox.ini" ]; then
    cp "${SOURCE_DIR}/tox.ini" "${PRODUCT_INSTALL}/tox.ini"
fi

if [ -d "${SOURCE_DIR}/tests" ]; then
    cp -r "${SOURCE_DIR}/tests" "${PRODUCT_INSTALL}/tests"
fi

if [ -f "${PRODUCT_INSTALL}/tox.ini" ] && [ -d "${PRODUCT_INSTALL}/tests" ]; then
    cd "${PRODUCT_INSTALL}"
    touch "${PRODUCT_INSTALL}/tests/__init__.py"
    tox -e test -- --ignore tests/test_nobatch.py #unstable test
    if [ $? -ne 0 ]; then
        echo "ERROR: pybatch tests fails"
        exit 5
    fi
    rm -rf "${PRODUCT_INSTALL}/.tox"
else
    echo "WARNING: pybatch tests have not be run"
fi

echo
echo "########## END"
