#!/bin/bash

echo "##########################################################################"
echo "libigl" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

CMAKE_OPTIONS=
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

if [ -n "$BOOST_ROOT_DIR" ] && [ "${SAT_boost_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DBoost_DIR:PATH=${Boost_DIR}"
    CMAKE_OPTIONS+=" -DBoost_INCLUDE_DIR:PATH=${BOOST_ROOT_DIR}/include"
fi

if [ -n "$FREETYPE_ROOT_DIR" ] && [ "${SAT_freetype_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DFREETYPE_ROOT_DIR:PATH=${FREETYPE_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DFREETYPE_INCLUDE_DIRS:STRING=${FREETYPE_ROOT_DIR}/include/freetype2"
    CMAKE_OPTIONS+=" -DFREETYPE_LIBRARY:STRING=${FREETYPE_ROOT_DIR}/lib/libfreetype.so"
    CMAKE_OPTIONS+=" -Dpkgcfg_lib_PKG_FONTCONFIG_free:STRING=${FREETYPE_ROOT_DIR}/lib/libfreetype.so"
fi

if [ -n "$LAPACK_ROOT_DIR" ] && [ "$SAT_lapack_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DLAPACK_DIR=${LAPACK_DIR}"
    CMAKE_OPTIONS+=" -DCBLAS_DIR=${CBLAS_DIR}"
    CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libcblas.so"
    CMAKE_OPTIONS+=" -DBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libblas.so"
fi

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR

if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
cd tutorial
make $MAKE_OPTIONS tutorial/CMakeFiles/609_Boolean.dir/rule 
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
mkdir -p ${PRODUCT_INSTALL}/bin
cp $BUILD_DIR/bin/609_Boolean ${PRODUCT_INSTALL}/bin
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi
chmod 755 ${PRODUCT_INSTALL}/bin/609_Boolean

cp -r ${SOURCE_DIR}/include ${PRODUCT_INSTALL}/include
if [ $? -ne 0 ]; then
    echo "ERROR on make install: could not copy include directory..."
    exit 4
fi

echo
echo "########## END"
