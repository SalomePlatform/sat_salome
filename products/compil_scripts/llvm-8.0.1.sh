#!/bin/bash

echo "##########################################################################"
echo "LLVM " $VERSION
echo "##########################################################################"
CMAKE_OPTION=""
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_BUILD_LLVM_DYLIB=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_ENABLE_RTTI=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_INSTALL_UTILS=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_TARGETS_TO_BUILD:STRING=X86"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_ENABLE_DUMP=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DPYTHON_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python"

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
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

