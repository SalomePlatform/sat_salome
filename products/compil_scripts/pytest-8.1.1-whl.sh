#!/bin/bash

echo "##########################################################################"
echo "pytest $VERSION"
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

rm -rf "${BUILD_DIR}"
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}" || { echo "cd ${BUILD_DIR} fails"; exit 1; }
cp -r "${SOURCE_DIR}"/* .

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_CACHE_DIR=${BUILD_DIR}/cache/pip
export PATH=${PRODUCT_INSTALL}/bin:$PATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** install with $PYTHONBIN -m pip install tomli-1.0.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv"
${PYTHONBIN} -m pip install tomli-1.0.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
echo "pip install exceptiongroup fails"
exit 1
fi

echo
echo "*** install with $PYTHONBIN -m pip install exceptiongroup-1.0.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv"
${PYTHONBIN} -m pip install exceptiongroup-1.0.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
echo "pip install exceptiongroup fails"
exit 1
fi

echo
echo "*** install with $PYTHONBIN -m pip install pluggy-1.4.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv"
${PYTHONBIN} -m pip install pluggy-1.4.0-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
echo "pip install exceptiongroup fails"
exit 1
fi

echo
echo "*** install with $PYTHONBIN -m pip install . --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv"
${PYTHONBIN} -m pip install pytest-8.1.1-py3-none-any.whl --no-binary :all: --prefix=$PRODUCT_INSTALL -vvv
if [ $? -ne 0 ]; then
echo "pip install pytest fails"
exit 1
fi

fix_lib_path

echo
echo "########## END"
