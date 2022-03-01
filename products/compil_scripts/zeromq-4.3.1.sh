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
### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${LIBXML2_ROOT_DIR}" != "/usr" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
cd  $BUILD_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR
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
