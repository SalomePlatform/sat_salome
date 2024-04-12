
#!/bin/bash

echo "##########################################################################"
echo "mpi4py" $VERSION
echo "##########################################################################"

echo  "*** build in SOURCE directory"
cd $BUILD_DIR
cp -R $SOURCE_DIR/* .

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN"
#$PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
$PYTHONBIN -m pip install --ignore-installed --cache-dir=$BUILD_DIR/cache/pip . --no-deps --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]; then
    echo "ERROR on build/install"
    exit 3
fi

echo
echo "########## END"
