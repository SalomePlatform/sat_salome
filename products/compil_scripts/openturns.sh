#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "openturns" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DPYTHON_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python"

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
