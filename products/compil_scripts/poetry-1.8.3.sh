#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "poetry " $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
echo "*** check installation"
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH
mkdir -p ${PRODUCT_INSTALL}
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR

USE_WHEELS=true
case $LINUX_DISTRIBUTION in
    DB10|UB20*|CO7)
	export WHEELS=('poetry-1.8.3-py3-none-any.whl')
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
if [ -d ${PRODUCT_INSTALL}/lib/python3.7/site-packages/bin ];then
    mv ${PRODUCT_INSTALL}/lib/python3.7/site-packages/bin* ${PRODUCT_INSTALL}/bin
fi

echo
echo "########## END"
