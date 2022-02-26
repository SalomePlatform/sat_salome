#!/bin/bash

echo "##########################################################################"
echo "PERSALYS" $VERSION
echo "##########################################################################"

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=$PRODUCT_INSTALL"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DADAO_ROOT_DIR=$ADAO_ROOT_DIR"
CMAKE_OPTIONS+=" -DADAO_INTERFACE_ROOT_DIR=$ADAO_INTERFACE_ROOT_DIR"
#CMAKE_OPTIONS+=" -DBOOST_ROOT:PATH=${BOOST_ROOT_DIR}"
CMAKE_OPTIONS+=" -DGUI_ROOT_DIR=$GUI_ROOT_DIR"
CMAKE_OPTIONS+=" -DKERNEL_ROOT_DIR=$KERNEL_ROOT_DIR"
CMAKE_OPTIONS+=" -DOpenTURNS_DIR=$OPENTURNS_ROOT_DIR"
CMAKE_OPTIONS+=" -DPY2CPP_ROOT_DIR=$PY2CPP_ROOT_DIR"
CMAKE_OPTIONS+=" -DPYTHON_ROOT_DIR=$PYTHON_ROOT_DIR"
CMAKE_OPTIONS+=" -DQWT_ROOT_DIR=$QWT_ROOT_DIR"
#!/bin/bash

echo "##########################################################################"
echo "PERSALYS" $VERSION
echo "##########################################################################"

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=$PRODUCT_INSTALL"
CMAKE_OPTIONS+=" -DADAO_ROOT_DIR=$ADAO_ROOT_DIR"
CMAKE_OPTIONS+=" -DADAO_INTERFACE_ROOT_DIR=$ADAO_INTERFACE_ROOT_DIR"
CMAKE_OPTIONS+=" -DBOOST_ROOT:PATH=${BOOST_ROOT_DIR}"
CMAKE_OPTIONS+=" -DGUI_ROOT_DIR=$GUI_ROOT_DIR"
CMAKE_OPTIONS+=" -DKERNEL_ROOT_DIR=$KERNEL_ROOT_DIR"
CMAKE_OPTIONS+=" -DOpenTURNS_DIR=$OPENTURNS_ROOT_DIR"
CMAKE_OPTIONS+=" -DPY2CPP_ROOT_DIR=$PY2CPP_ROOT_DIR"
CMAKE_OPTIONS+=" -DPYTHON_ROOT_DIR=$PYTHON_ROOT_DIR"
CMAKE_OPTIONS+=" -DQWT_LIBRARY=$QWT_ROOT_DIR/lib/libqwt.so"
CMAKE_OPTIONS+=" -DQWT_INCLUDE_DIR=$QWT_ROOT_DIR/include"
CMAKE_OPTIONS+=" -DSPHINX_ROOT_DIR=$SPHINX_ROOT_DIR"
CMAKE_OPTIONS+=" -DYACS_ROOT_DIR=$YACS_ROOT_DIR"
CMAKE_OPTIONS+=" -DYDEFX_ROOT_DIR=$YDEFX_ROOT_DIR"
CMAKE_OPTIONS+=" -DAdaoCppLayer_INCLUDE_DIR=$ADAO_INTERFACE_ROOT_DIR/include"
CMAKE_OPTIONS+=" -DAdaoCppLayer_ROOT_DIR=$ADAO_INTERFACE_ROOT_DIR"
CMAKE_OPTIONS+=" -DUSE_SALOME=ON"
CMAKE_OPTIONS+=" -DGDAL_LIBRARY=$GDALHOME/lib/libgdal.so"
CMAKE_OPTIONS+=" -DGDAL_INCLUDE_DIR=$GDALHOME/include"
CMAKE_OPTIONS+=" -DTBB_ROOT=$TBB_ROOT_DIR"
CMAKE_OPTIONS+=" -DTBB_INCLUDE_DIR=$TBB_ROOT_DIR/include"
CMAKE_OPTIONS+=" -DMPI_C_FOUND=$MPI_C_FOUND"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=$PYTHONBIN"
CMAKE_OPTIONS+=" -DOTGUI_PYTHON_VERSION=$PYTHON_VERSION"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE"
CMAKE_OPTIONS+=" -DPYTHON_LIBRARY=$PYTHON_ROOT_DIR/lib/libpython$PYTHON_VERSION.so"
CMAKE_OPTIONS+=" -DCAS_ROOT_DIR=$CAS_ROOT_DIR"
CMAKE_OPTIONS+=" -DSPHINX_ROOT_DIR:FILEPATH=$SPHINX_ROOT_DIR"
CMAKE_OPTIONS+=" -DSPHINX_EXECUTABLE:FILEPATH=${SPHINX_ROOT_DIR}/bin/sphinx-build"
CMAKE_OPTIONS+=" -DCMAKE_FIND_ROOT_PATH=ON"
CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE:PATH=$(which swig)"
CMAKE_OPTIONS+=" -DCMAKE_PREFIX_PATH=\"$GUI_ROOT_DIR/adm_local/cmake_files;$KERNEL_ROOT_DIR/salome_adm/cmake_files;$OPENTURNS_HOME/lib/cmake/openturns;$PY2CPP_ROOT_DIR/lib/cmake/py2cpp/;$QWT_ROOT_DIR;$YACS_ROOT_DIR/adm/cmake;$YDEFX_ROOT_DIR/salome_adm/cmake_files;\""

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
echo "########## END"

