#!/bin/bash

echo "##########################################################################"
echo "TopIIVolMesh" $VERSION
echo "##########################################################################"

export CC=$(which mpicc)
export CXX=$(which mpicxx)
export MPICXX=$(which mpic++)

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=" --with-MPICXX=${MPICXX}"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

cp -r $SOURCE_DIR/* .

echo
echo "*** autoreconf -i"
autoreconf -i
if [ $? -ne 0 ]
then
    echo "ERROR on autoreconf command"
    exit 1
fi

echo
echo "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS" 
$BUILD_DIR/configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
fi
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

echo
echo "*** Check if node is a virtual machine"
ISVM=$(hostnamectl status|grep -i chassis:|grep vm)
if [ ! -z "$ISVM" ]; then
    echo "*** oversubscribe..."
    sed -i 's/mpirun -np \$(NP)/mpirun -np \$(NP) --oversubscribe/g' src/*/Makefile.am
else
    echo "*** hostnamectl says that $HOSTNAME is *NOT* a virtual machine"
fi

make check
if [ $? -ne 0 ]
then
    echo "ERROR on make check"
    exit 5
fi

echo
echo "########## END"

