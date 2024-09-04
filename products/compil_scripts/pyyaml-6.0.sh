#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "pyyaml " $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
echo "*** check installation"
mkdir -p ${PRODUCT_INSTALL}
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH
USE_WHEELS=true
case $LINUX_DISTRIBUTION in
    DB11|CO7)
	export WHEELS=('PyYAML-6.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl')
	;;
    *)
	exit 1
	;;
esac
if $USE_WHEELS == true ; then
    for WHEEL in "${WHEELS[@]}"; do
	echo $WHELL
	${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
	if [ $? -ne 0 ]; then
            echo "ERROR: could not install $WHEEL"
            exit 1
	fi
    done
else
    echo "Not implemented"
fi

echo
echo "########## END"
