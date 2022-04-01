#!/bin/bash

echo "##########################################################################"
echo "gdal" $VERSION
echo "##########################################################################"

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=" --with-pcraster=internal"
CONFIGURE_FLAGS+=" --with-png=internal"
CONFIGURE_FLAGS+=" --with-libtiff=internal"
CONFIGURE_FLAGS+=" --with-geotiff=internal"
CONFIGURE_FLAGS+=" --with-jpeg=internal"
CONFIGURE_FLAGS+=" --with-gif=internal"
CONFIGURE_FLAGS+=" --with-python=yes"
CONFIGURE_FLAGS+=" --with-geos=yes"
CONFIGURE_FLAGS+=" --with-sqlite3=yes"
CONFIGURE_FLAGS+=" --with-threads"
CONFIGURE_FLAGS+=" --with-python=${PYTHONBIN}"
CONFIGURE_FLAGS+=" --with-hdf5=${HDF5_ROOT_DIR}"
CONFIGURE_FLAGS+=" --with-netcdf=${NETCDF_ROOT_DIR}"

if [[ "$DIST_NAME$DIST_VERSION" == "CO8" ]]; then
    CONFIGURE_FLAGS+=" --without-jasper"
fi

if [ ! -z "$LIBXML_ROOT_DIR" ]; then
    CONFIGURE_FLAGS+=" --with-xml2=${LIBXML_ROOT_DIR}"
fi
echo
echo "*** configure $CONFIGURE_FLAGS LDFLAGS=\"-L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl -L${NETCDF_ROOT_DIR}/lib -lnetcdf\" HDF5_CFLAGS=\"-I${HDF5HOME}/include -L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl\" LIBS=\"-L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl -L${NETCDF_INSTALL_DIR}/lib -lnetcdf\" HDF5_LIBS=\"-L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl \" HDF5_INCLUDE=\"-I${HDF5HOME}/include\""

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cp -r $SOURCE_DIR/gdal $BUILD_DIR/gdal
cd $BUILD_DIR/gdal
./configure --prefix=$PRODUCT_INSTALL $CONFIGURE_FLAGS LDFLAGS="-L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl -L${NETCDF_INSTALL_DIR}/lib -lnetcdf" HDF5_CFLAGS="-I${HDF5HOME}/include -L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl" LIBS="-L${HDF5HOME}/lib/ -lhdf5 -lhdf5_hl -L${NETCDF_INSTALL_DIR}/lib -lnetcdf" HDF5_LIBS="-L${HDF5HOME}/lib/ -lhdf5  -lhdf5_hl " HDF5_INCLUDE="-I${HDF5HOME}/include"
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

