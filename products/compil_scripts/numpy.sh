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
if [ $? -ne 0 ]; then
    echo "ERROR on setup build install"
    rm -f site.cfg
    exit 1
fi
# the embedded versioneer.py fails to retrieve the correct version - presumably because of missing .git information
# let's fix this once for all - prevents openturns from not building.
cd ${NUMPY_INSTALL}
if [ -f numpy/_version.py ]; then
    echo "INFO: ensure that version is consistently set. In principle patches "
    sed -i "s/0+unknown/$VERSION/g" numpy/_version.py
else
    f=$(find . -type d -name "numpy-$VERSION-py${PYTHON_VERSION}-*x86_64.egg")
    if [ $? -eq 0 ]; then
	      EGG_DIR=$(ls |grep numpy-$VERSION-py${PYTHON_VERSION} |grep x86_64.egg)
	      echo "INFO:  Found $EGG_DIR"
	      if [ -d $EGG_DIR/numpy ]; then
	          ln -sf $EGG_DIR/numpy
	          sed -i "s/0+unknown/$VERSION/g" $EGG_DIR/numpy/_version.py
	      else
	          echo "WARNING: could not find $EGG_DIR/numpy"
	      fi
    else
	      echo "WARNING: could not find egg directory with name: numpy-$VERSION-py${PYTHON_VERSION}-*-x86_64.egg"
    fi
fi

if [ -d ${PRODUCT_INSTALL}/local/bin ]; then
    mv ${PRODUCT_INSTALL}/local/bin ${PRODUCT_INSTALL}/bin
    rm -rf ${PRODUCT_INSTALL}/local
fi

rm -f site.cfg
echo
echo "########## END"

