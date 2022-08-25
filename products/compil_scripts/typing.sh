#!/bin/bash

echo "##########################################################################"
echo "typing $VERSION"
echo "##########################################################################"



echo  "*** build in SOURCE directory"
cd $SOURCE_DIR

mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** install with $PYTHONBIN $PYTHON_VERSION"
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

if version_ge $PYTHON_VERSION "3."; then
    echo "***  $VERSION >= 2.X is not supported and was not tested! Please, report this issue to SALOME support!"
    exit 3
else
    $PYTHONBIN pip-10.0.1-py2.py3-none-any.whl/pip install --no-index --target $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages typing-${VERSION}-py2-none-any.whl
    if [ $? -ne 0 ]
    then
        echo "ERROR on install" $?
        exit 3
    fi
fi

echo
echo "########## END"
