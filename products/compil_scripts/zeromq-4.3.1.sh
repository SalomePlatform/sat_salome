#!/bin/bash

echo "##########################################################################"
echo "zeromq" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
### libxml2 settings
if [ "${SAT_libxml2_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi
if [ -n "$MPI_ROOT_DIR" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER}"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER}"
fi

if [ $LINUX_DISTRIBUTION == "CO8" ]; then
    CMAKE_OPTIONS+=" -DWITH_DOCS:BOOL=OFF"
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
