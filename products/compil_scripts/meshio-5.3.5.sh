#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "meshio" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo "*** check installation"
mkdir -p ${PRODUCT_INSTALL}
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH

WHEELS=('typing_extensions-4.11.0-py3-none-any.whl'
        'meshio-5.3.5-py3-none-any.whl'
       )
for WHEEL in "${WHEELS[@]}"; do
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    if [ $? -ne 0 ]; then
        echo "ERROR: could not install $WHEEL"
        exit 1
    fi
done

pyVersionMajor=python$($PYTHONBIN -c 'import sys; print(".".join(map(str, sys.version_info[0:1])))')
if [ $? -ne 0 ]; then
	  echo ERROR: Failed to extract major Python version -  assuming Python version equal to 3...
	  pyVersionMajor=python3
fi
echo INFO: Python version major: ${pyVersionMajor}
if [ -f $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/bin/meshio ]; then
    sed -i "s%#\!.*python[0-9]*%#\!/usr/bin/env ${pyVersionMajor}%#g" $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/bin/meshio
else
    echo "FATAL: could not find meshio runner!"
    exit  1
fi

echo
echo "########## END"
