#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "openturns" $VERSION
echo "##########################################################################"

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python"
CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"

echo
echo "*** cmake" $CMAKE_OPTIONS
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
echo "*** check installation"

if [ -d "${PRODUCT_INSTALL}/lib64" ]
then
    mv ${PRODUCT_INSTALL}/lib64/* ${PRODUCT_INSTALL}/lib
    rmdir ${PRODUCT_INSTALL}/lib64
fi

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}
export LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib:${LD_LIBRARY_PATH}
chmod +x ${SOURCE_DIR}/python/test/t_features.py
${SOURCE_DIR}/python/test/t_features.py
if [ $? -ne 0 ]
then
    echo "ERROR  testing Openturns features...."
    exit 4
fi

echo
echo "########## END"
