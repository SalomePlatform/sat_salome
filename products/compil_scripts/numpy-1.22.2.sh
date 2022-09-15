#!/bin/bash

echo "##########################################################################"
echo "numpy" $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL

cd $SOURCE_DIR
rm -f site.cfg

if [ "$SAT_lapack_IS_NATIVE" != "1" ]; then
    echo "Lapack is embedded... Make numpy aware of it..."
    echo "[ALL]"                                             > site.cfg
    echo "libraries = lapack,blas,cblas,lapacke,tmglib"     >> site.cfg
    echo "library_dirs = \$\{LAPACKHOME\}/lib"              >> site.cfg
    echo "include_dirs = \$\{LAPACKHOME\}/include"          >> site.cfg
fi

export PYTHONPATH=$SOURCE_DIR:$PYTHONPATH

NUMPY_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${NUMPY_INSTALL}
PYTHONPATH=${NUMPY_INSTALL}:${PYTHONPATH}

echo
echo "*** setup.py build install"
$PYTHONBIN setup.py build install --prefix=${PRODUCT_INSTALL} --install-lib=${NUMPY_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on setup build install"
    rm -f site.cfg
    exit 1
fi
# the embedded versioneer.py fails to retrieve the correct version - presumably because of missing .git information
# let's fix this once for all - prevents openturns from not building.
cd ${NUMPY_INSTALL}
EGG_OLD=$(ls )
EGG_DIR=numpy-$VERSION-py${PYTHON_VERSION}-linux-x86_64.egg
echo "====> $EGG_DIR"
mv numpy*-linux-x86_64.egg  $EGG_DIR
ln -sf $EGG_DIR/numpy numpy
sed -i "s/0+unknown/$VERSION/g" $EGG_DIR/numpy/_version.py

if [ -d ${PRODUCT_INSTALL}/local/bin ]; then
    mv ${PRODUCT_INSTALL}/local/bin ${PRODUCT_INSTALL}/bin
    rm -rf ${PRODUCT_INSTALL}/local
fi

rm -f site.cfg
echo
echo "########## END"

