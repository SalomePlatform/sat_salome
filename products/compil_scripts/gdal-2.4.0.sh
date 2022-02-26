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

./configure --prefix=$CURRENT_SOFTWARE_INSTALL_DIR
LDFLAGS=
LDFLAGS+=" -L${HDF5_ROOT_DIR}/lib/ -lhdf5 -L${HDF5_ROOT_DIR}/lib/libhdf5_hl.so -lhdf5_hl"
LDFLAGS+=" -L${NETCDF_ROOT_DIR}/lib -lnetcdf"

HDF5_CFLAGS=
HDF5_CFLAGS+=" -I${HDF5_ROOT_DIR}/include -L${HDF5_ROOT_DIR}/lib/ -lhdf5"
HDF5_CFLAGS+=" -L${HDF5_ROOT_DIR}/lib/libhdf5_hl.so -lhdf5_hl"

LIBS=
LIBS+=" -L${HDF5_ROOT_DIR}/lib/ -lhdf5 -L${HDF5_ROOT_DIR}/lib/libhdf5_hl.so -lhdf5_hl"
LIBS+=" -L${NETCDF_ROOT_DIR}/lib -lnetcdf"

HDF5_LIBS="-L${HDF5_ROOT_DIR}/lib/ -lhdf5 -L${HDF5_ROOT_DIR}/lib/libhdf5_hl.so -lhdf5_hl"
HDF5_INCLUDE="-I${HDF5_ROOT_DIR}/include"

CONFIGURE_FLAGS=
#CONFIGURE_FLAGS+=" LDFLAGS=\"$LDFLAGS\""
#CONFIGURE_FLAGS+=" HDF5_CFLAGS=\"$HDF5_CFLAGS\""
#CONFIGURE_FLAGS+=" LIBS=\"$LIBS\""
#CONFIGURE_FLAGS+=" HDF5_LIBS=\"$HDF5_LIBS\""
#CONFIGURE_FLAGS+=" HDF5_INCLUDE=\"$HDF5_INCLUDE\""
CONFIGURE_FLAGS+=" --with-pcraster=internal"
CONFIGURE_FLAGS+=" --with-png=internal"
CONFIGURE_FLAGS+=" --with-libtiff=internal"
CONFIGURE_FLAGS+=" --with-geotiff=internal"
CONFIGURE_FLAGS+=" --with-jpeg=internal"
CONFIGURE_FLAGS+=" --with-gif=internal"
CONFIGURE_FLAGS+=" --with-python=yes"
CONFIGURE_FLAGS+=" --with-geos=yes"
CONFIGURE_FLAGS+=" --with-sqlite3=yes"
CONFIGURE_FLAGS+=" --with-hdf5=${HDF5_ROOT_DIR}"
CONFIGURE_FLAGS+=" --with-netcdf=${NETCDF_ROOT_DIR}"

echo
echo "*** configure $CONFIGURE_FLAGS"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $SOURCE_DIR/gdal
./configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
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

