#!/bin/bash

echo "##########################################################################"
echo "gdal" $VERSION
echo "##########################################################################"

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=" --with-threads"
CONFIGURE_FLAGS+=" --with-python=${PYTHONBIN}"
CONFIGURE_FLAGS+=" --with-xml2=${LIBXML_ROOT_DIR}"
CONFIGURE_FLAGS+=" --with-hdf5=${HDF5_ROOT_DIR}"
CONFIGURE_FLAGS+=" --with-netcdf=${NETCDF_ROOT_DIR}"

echo
echo "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $SOURCE_DIR
$SOURCE_DIR/gdal/configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi
echo
echo "*** make" $MAKE_OPTIONS
make -F GNUMakefile $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

