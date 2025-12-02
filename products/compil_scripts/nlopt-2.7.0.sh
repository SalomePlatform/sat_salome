#!/bin/bash

echo "##########################################################################"
echo "nlopt" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""

### common compiler and install settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

if [ -n "$SWIG_ROOT_DIR" ] && [ "$SAT_swig_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
fi
CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DNLOPT_MATLAB:BOOL=OFF"
CMAKE_OPTIONS+=" -DNLOPT_OCTAVE:BOOL=OFF"
CMAKE_OPTIONS+=" -DNLOPT_GUILE:BOOL=OFF"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

echo
echo "*** cmake" $CMAKE_OPTIONS

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
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


if [ -d "${PRODUCT_INSTALL}/lib64" ]; then
    if [ -d "$PRODUCT_INSTALL/lib" ]; then
        cp -r $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION $PRODUCT_INSTALL/lib/
    else
        echo "WARNING: moving lib64 to lib"
        mv $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION/site-packages/* $PRODUCT_INSTALL/lib/python$PYTHON_VERSION/site-packages/
    fi
    rm -rf ${PRODUCT_INSTALL}/lib64
elif [ -d "${PRODUCT_INSTALL}/local/lib64" ]; then
    echo "WARNING: moving local/lib64 to lib"
    mv $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION/site-packages/* $PRODUCT_INSTALL/lib/python$PYTHON_VERSION/site-packages/
    rm -rf ${PRODUCT_INSTALL}/local/lib64
fi

echo
echo "########## END"

