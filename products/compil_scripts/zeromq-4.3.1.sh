#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "zeromq" $VERSION
echo "##########################################################################"

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

if [ -n "$TBB_ROOT_DIR" ] && [ "${TBB_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DTBB_ROOT_DIR=${TBB_ROOT_DIR}"
fi

### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${LIBXML2_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

# HDF5
if [ -n "$HDF5_ROOT_DIR" ] && [ "${HDF5_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"
    CMAKE_OPTIONS+=" -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF"
    CMAKE_OPTIONS+=" -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib"
    CMAKE_OPTIONS+=" -DHDF5_hdf5_hl_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
    CMAKE_OPTIONS+=" -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
    CMAKE_OPTIONS+=" -DHDF5_C_INCLUDE_DIR=${HDF5_ROOT_DIR}/include"
fi

### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${LIBXML2_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

## nlopt
if [ -n "$NLOPT_ROOT_DIR" ] && [ "${NLOPT_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DNLOPT_INCLUDE_DIRS:STRING=${NLOPT_ROOT_DIR}/include"
    CMAKE_OPTIONS+=" -DNLOPT_LIBRARIES:STRING=${NLOPT_ROOT_DIR}/lib"
    CMAKE_OPTIONS+=" -DNLOPT_DIR:STRING=${NLOPT_ROOT_DIR}"
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
cd  $BUILD_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR/
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
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
