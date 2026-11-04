#!/bin/bash

echo "##########################################################################"
echo "URANIE " $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
if [ $DIST_NAME = "macOS" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD:STRING=17"
else
    CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD:STRING=14"
fi
CMAKE_OPTIONS+=" -DWITH-OPT++:BOOL=ON"
CMAKE_OPTIONS+=" -DWITH-JSONCPP:BOOL=OFF"
CMAKE_OPTIONS+=" -D--enable-doc:BOOL=ON"
CMAKE_OPTIONS+=" -D--disable-cuda:BOOL=ON"
CMAKE_OPTIONS+=" -DPython_EXECUTABLE=${PYTHONBIN}"

if [ $DIST_NAME = "macOS" ]; then
    export ROOT_INCLUDE_PATH=${BOOST_ROOT_DIR}/INSTALL/boost/include${ROOT_INCLUDE_PATH:+:$ROOT_INCLUDE_PATH}
    BOOST_INC="$BOOST_ROOT_DIR/include"
    [ -f "$BOOST_INC/boost/coroutine2/all.hpp" ] || echo "coroutine2 absent de $BOOST_INC"
    # compilateur C++ : CMake lit CXXFLAGS au premier configure
    export CXXFLAGS="-I$BOOST_INC ${CXXFLAGS}"

    CMAKE_OPTIONS+=" ${SAT_CMAKE_OPTIONS}"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=${BOOST_ROOT_DIR}/include/boost/coroutine2"
fi

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

echo "*** cmake $CMAKE_OPTIONS $SOURCE_DIR"
cmake $CMAKE_OPTIONS $SOURCE_DIR

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
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
echo "########## END"
