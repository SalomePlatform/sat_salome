#!/bin/bash

echo "##########################################################################"
echo "topo2volmesh" $VERSION
echo "##########################################################################"

CONFIGURE_FLAGS=
if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
else
    if [[ $DIST_NAME == "CO" && $DIST_VERSION == "7" ]]; then
	# check whether openmpi is installed
	x=$(yum list installed |grep openmpi)
	if [ $? -ne 0 ]; then
	    echo "ERROR: openMPI is not installed!"
	    exit 1
	fi
	export CC=/usr/lib64/openmpi/bin/mpicc
	export CXX=/usr/lib64/openmpi/bin/mpicxx
	export PATH=$PATH:/usr/lib64/openmpi/bin
	CONFIGURE_FLAGS+=" --with-MPICXX=/usr/lib64/openmpi/bin/mpic++"
    fi
fi

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

make check
if [ $? -ne 0 ]
then
    echo "ERROR on make check"
    exit 5
fi

echo
echo "########## END"

