#!/bin/bash

echo "##########################################################################"
echo "CoreFlows" $VERSION
echo "##########################################################################"


mkdir -p $PRODUCT_INSTALL

#==============
#rm -rf $CoreFlows_build $CoreFlows_INSTALL
#mkdir -p $CoreFlows_build
#mkdir -p $CoreFlows_INSTALL
#==============

#cd $BUILD_DIR

#================ A MODIFIER =============================
# CDMATH_DIR, PETSC_DIR, PETSC_ARCH, CoreFlows_ROOT : Paths to be set by the user 
export CDMATH_DIR=${CDMATH_ROOT_DIR}
export PETSC_DIR=${PETSC_ROOT_DIR}
export PETSC_ARCH=arch-linux2-c-debug # usually for fedora: arch-linux2-c-opt or arch-linux2-c-debug, for ubuntu: linux-gnu-c-opt or linux-gnu-c-debug
export CoreFlows_ROOT=$SOURCE_DIR
export CoreFlows_INSTALL=$PRODUCT_INSTALL

#Compilation options (PYTHON, Doc, GUI) to be set by the user
export CoreFlows_PYTHON='ON'   # To generate the SWIG module "Python = ON or OFF "
export CoreFlows_DOC='ON'      # To generate the Documentation  "Doc = ON or OFF "
export CoreFlows_GUI='ON'      # To generate the Graphic user interface  "GUI = ON or OFF "

#------------------------------------------------------------------------------------------------------------------- 
export CoreFlows=$CoreFlows_INSTALL/bin/Executable/CoreFlowsMainExe
export LD_LIBRARY_PATH=$CDMATH_DIR/lib/:$PETSC_DIR/$PETSC_ARCH/lib:$CoreFlows_INSTALL/lib:${LD_LIBRARY_PATH}
export PYTHONPATH=$CoreFlows_INSTALL/lib:$CoreFlows_INSTALL/lib/CoreFlows_Python:$CoreFlows_INSTALL/bin/CoreFlows_Python:$CoreFlows_INSTALL/lib/python2.7/site-packages/salome:$CDMATH_DIR/lib/:$CDMATH_DIR/lib/cdmath:$CDMATH_DIR/bin/cdmath:${PYTHONPATH}
export CoreFlowsGUI=$CoreFlows_INSTALL/bin/salome/CoreFlows_Standalone.py
export COREFLOWS_ROOT_DIR=$CoreFlows_INSTALL
#=========================================================

#CMAKE_OPTIONS="$CoreFlows_ROOT/CoreFlows_src -DCMAKE_INSTALL_PREFIX=$CoreFlows_INSTALL -DCMAKE_BUILD_TYPE=Debug -G"Eclipse CDT4 - Unix Makefiles" -D_ECLIPSE_VERSION=4.3 -DCOREFLOWS_WITH_DOCUMENTATION=$CoreFlows_DOC -DCOREFLOWS_WITH_PYTHON=$CoreFlows_PYTHON -DCOREFLOWS_WITH_GUI=$CoreFlows_GUI -DCOREFLOWS_WITH_PACKAGE=OFF"
CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$CoreFlows_INSTALL -DCMAKE_BUILD_TYPE=Debug -DCOREFLOWS_WITH_DOCUMENTATION=$CoreFlows_DOC -DCOREFLOWS_WITH_PYTHON=$CoreFlows_PYTHON -DCOREFLOWS_WITH_GUI=$CoreFlows_GUI -DCOREFLOWS_WITH_PACKAGE=OFF"

echo
echo "*** cmake" $CMAKE_OPTIONS
cmake $SOURCE_DIR/CoreFlows_src $CMAKE_OPTIONS 

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make"
make
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

cd ..
chmod -R 755 $CoreFlows_INSTALL/bin/CoreFlows_Python/* $CoreFlows_INSTALL/share/examples/Python/*

echo
echo "########## END"
