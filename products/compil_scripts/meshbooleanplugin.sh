#!/bin/bash

echo "##########################################################################"
echo "meshboolean" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

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
CMAKE_OPTIONS+=" -DUSE_SAT=ON"

echo "*** cmake" $CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]; then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

if [ -f ${PRODUCT_INSTALL}/plugins/meshbooleanplugin/MyPlugDialog_ui.py ]; then
    sed '$d' ${PRODUCT_INSTALL}/plugins/meshbooleanplugin/MyPlugDialog_ui.py > ${BUILD_DIR}/MyPlugDialog_ui.py
    echo "from qwt import QwtPlot" >> ${BUILD_DIR}/MyPlugDialog_ui.py
    echo                           >> ${BUILD_DIR}/MyPlugDialog_ui.py
    mv ${BUILD_DIR}/MyPlugDialog_ui.py ${PRODUCT_INSTALL}/plugins/meshbooleanplugin/MyPlugDialog_ui.py
    if [ $? -ne 0 ]; then
	echo "could not overwrite MyPlugDialog_ui.py"
	exit 1
    fi
else
    echo "ERROR: could not find MyPlugDialog_ui.py"
    exit 1
fi

echo
echo "########## END"
