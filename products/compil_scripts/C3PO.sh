#!/bin/bash

echo "##########################################################################"
echo "C3PO" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cp -r $SOURCE_DIR/* .
LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

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

echo "INFO: check presence of $PRODUCT_INSTALL/local"
if [ -d "$PRODUCT_INSTALL/local" ]; then
    echo "INFO: $PRODUCT_INSTALL/local is present -  reearrange ..."
    if [ -d ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ]; then
        mv ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/site-packages
    fi
    for D in $(ls $PRODUCT_INSTALL/local); do
        echo "INFO: next subdirectory: $PRODUCT_INSTALL/local/$D"
        if [ -d $PRODUCT_INSTALL/$D ]; then
            cp -r $PRODUCT_INSTALL/local/$D/* $PRODUCT_INSTALL/$D/
        else
            mv $PRODUCT_INSTALL/local/$D $PRODUCT_INSTALL/$D
        fi
    done
    rm -rf $PRODUCT_INSTALL/local
fi

if [ -d $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/c3po-2.0-py${PYTHON_VERSION}.egg/c3po ]; then
    echo "WARNING: rearrange site-packages/c3po"
    mv $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/c3po-2.0-py${PYTHON_VERSION}.egg/c3po  $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/c3po
fi

export LD_LIBRARY_PATH="${MEDCOUPLING_ROOT_DIR}/lib:${LD_LIBRARY_PATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/${PYTHON_LIBDIR}:${PYTHONPATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/lib:${PYTHONPATH}"
export PYTHONPATH="${MEDCOUPLING_ROOT_DIR}/bin:${PYTHONPATH}"
cd $BUILD_DIR
if [ "$MPI_ROOT_DIR" != "" ]; then
    case $LINUX_DISTRIBUTION in
        DB09)
            ctest -E "Dussaix_seq|Dussaix_master_worker|Dussaix_collaborative|Listings_collaboratif"
            ;;
        *)
            ctest .
            ;;
    esac
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
