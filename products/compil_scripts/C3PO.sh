#!/bin/bash

echo "##########################################################################"
echo "C3PO" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .

# spns #29973
for X in env.sh runAllTests.sh; do
    echo "INFO: remove $X if present..."
    find . -name $X |xargs rm -f
done

mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
export PATH=${PRODUCT_INSTALL}/bin:$PATH
export PYTHONPATH=$PWD:$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

echo
echo "*** build and install with $PYTHONBIN sources/setup.py install --prefix=$PRODUCT_INSTALL"
cd sources
$PYTHONBIN ./setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 3
fi

$PYTHONBIN ./setup.py install --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 4
fi

export LD_LIBRARY_PATH="${MEDCOUPLING_ROOT_DIR}/lib:${LD_LIBRARY_PATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/${PYTHON_LIBDIR}:${PYTHONPATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/lib:${PYTHONPATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/bin:${PYTHONPATH}"
cd $BUILD_DIR
if [ -n "$MPI_ROOT_DIR" ]; then
    ctest .
else
    # these tests use MPI...
    ctest -E "Dussaix_seq|Dussaix_master_worker|Dussaix_collaborative|Listings_collaboratif"
fi
if [ $? -ne 0 ]
then
    echo "ERROR on ctest"
    exit 5
fi

echo
echo "########## END"
