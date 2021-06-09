#!/bin/bash

echo "##########################################################################"
echo "ParaView" $VERSION
echo "##########################################################################"




echo "Resize image in plugin SurfaceLIC doc"
BUILD_DIR=`pwd`
cd $SOURCE_DIR/Plugins/SurfaceLIC/doc/
convert surface_lic.png -resize 400 surface_lic2.png
if [ $? -ne 0 ]
then
    echo "convert command failed"
    exit 1
fi
mv surface_lic2.png surface_lic.png
cd $BUILD_DIR


python_name=python$PYTHON_VERSION

CMAKE_OPTIONS=""

### common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DBUILD_TESTING:BOOL=OFF"

### compiler settings
CMAKE_OPTIONS+=" -DVTK_HAVE_GETSOCKNAME_WITH_SOCKLEN_T=1"
CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=`which g++`"
CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=`which gcc`"
if [[ $BITS == "64" ]]
then
    CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS:STRING=-m64"
    CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS:STRING=-m64"
fi

### Paraview general settings
CMAKE_OPTIONS+=" -DPARAVIEW_INSTALL_DEVELOPMENT:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_USE_OGGTHEORA_ENCODER:BOOL=ON"
#CMAKE_OPTIONS+=" -DPARAVIEW_USE_MPI:BOOL=ON"

### VTK general settings
CMAKE_OPTIONS+=" -DVTK_USE_HYBRID:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_USE_PARALLEL:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_USE_PATENTED:BOOL=OFF"
CMAKE_OPTIONS+=" -DVTK_USE_RENDERING:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_USE_64BIT_IDS:BOOL=OFF"

### Qt settings
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_QT_GUI:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_QT_USE_WEBKIT:BOOL=ON"

### Python settings
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_WRAP_PYTHON:BOOL=ON"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE:STRING=${PYTHON_ROOT_DIR}/bin/${python_name}"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_PATH:STRING=${PYTHON_ROOT_DIR}/include/${python_name}"
CMAKE_OPTIONS+=" -DPYTHON_LIBRARY:STRING=${PYTHON_ROOT_DIR}/lib/${python_name}/config/lib${python_name}.so"

### No tcl tk wrap
CMAKE_OPTIONS+=" -DVTK_WRAP_TCL:BOOL=OFF"
CMAKE_OPTIONS+=" -DVTK_USE_TK:BOOL=OFF"

### HDF5 settings
CMAKE_OPTIONS+=" -DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
CMAKE_OPTIONS+=" -DHDF5_INCLUDE_DIR:STRING=${HDF5HOME}/include"
CMAKE_OPTIONS+=" -DHDF5_LIBRARY:STRING=${HDF5HOME}/lib/libhdf5.so"

### VisIt Database bridge settings
CMAKE_OPTIONS+=" -DPARAVIEW_USE_VISITBRIDGE:BOOL=ON"
CMAKE_OPTIONS+=" -DBOOST_ROOT=${BOOSTDIR}"

### gl2ps settings
CMAKE_OPTIONS+=" -DVTK_USE_GL2PS:BOOL=ON"
CMAKE_OPTIONS+=" -DVTK_USE_SYSTEM_GL2PS:BOOL=ON"
CMAKE_OPTIONS+=" -DGL2PS_INCLUDE_DIR:STRING=${GL2PSDIR}/include"
CMAKE_OPTIONS+=" -DGL2PS_LIBRARY:STRING=${GL2PSDIR}/lib/libgl2ps.so"

### Extra options (switch off non-used Paraview plug-ins)
#CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_CoProcessing:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_Moments:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_Prism:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SLACTools:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SierraPlotTools:BOOL=OFF"
#CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_VisTrailsPlugin:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_pvblot:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_COPROCESSING:BOOL=OFF"

### Extra options (switch on required Paraview plug-ins)
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_ForceTime:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_H5PartReader:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_PointSprite:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SurfaceLIC:BOOL=ON"

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 2
fi

MAKE_OPTIONS="VERBOSE=1 "$MAKE_OPTIONS
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
echo "Copy some missing files"
PVCMAKEDIR=$PRODUCT_INSTALL/lib/paraview-3.14/CMake
cp ../CMake/generate_proxydocumentation.cmake $PVCMAKEDIR
cp ../CMake/smxml_to_xml.xsl $PVCMAKEDIR
cp ../CMake/xml_to_html.xsl $PVCMAKEDIR
cp ../CMake/xml_to_wiki.xsl.in $PVCMAKEDIR
cp ../CMake/generate_qhp.cmake $PVCMAKEDIR


echo
echo "########## END"

