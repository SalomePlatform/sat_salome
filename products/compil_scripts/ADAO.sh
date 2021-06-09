#!/bin/bash

echo "##########################################################################"
echo "ADAO/ADAO_TOOL" $VERSION
echo "##########################################################################"


PYTHON_VERSION_MAJ=${PYTHON_VERSION:0:1}

echo "##########################################################################"
echo "Compile ADAO TOOL"
echo "##########################################################################"

export CURRENT_SOFTWARE_INSTALL_DIR=${PRODUCT_INSTALL}

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

MAKE_OPTIONS="VERBOSE=1 "$MAKE_OPTIONS
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo "##########################################################################"
echo "Compile ADAO MODULE"
echo "##########################################################################"
export ADAO_PYTHON_ROOT_DIR=${CURRENT_SOFTWARE_INSTALL_DIR}
export ADAO_ENGINE_ROOT_DIR==${CURRENT_SOFTWARE_INSTALL_DIR}
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION:0:3}/site-packages:$PYTHONPATH


CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DADAO_PYTHON_MODULE=OFF"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DKERNEL_ROOT_DIR=${KERNEL_ROOT_DIR}"
CMAKE_OPTIONS+=" -DADAO_PYTHON_ROOT_DIR=${ADAO_PYTHON_ROOT_DIR}"
CMAKE_OPTIONS+=" -DEFICAS_ROOT_DIR=${EFICAS_TOOLS_ROOT_DIR}"

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

MAKE_OPTIONS="VERBOSE=1 "$MAKE_OPTIONS
echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi



