#!/bin/bash

echo "##########################################################################"
echo "ParaView" $VERSION
echo "##########################################################################"



PVLIBVERSION=`echo ${VERSION} | awk -F. '{printf("%d.%d",$1,$2)}'`
export python_name=python$PYTHON_VERSION

CMAKE_OPTIONS=""

### verbose log
CMAKE_OPTIONS+=" -DCMAKE_VERBOSE_MAKEFILE=ON"

### common settings
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DBUILD_TESTING:BOOL=OFF"

### for import/export in CGNS format
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_CGNS=ON"


### compiler settings
if [[ $BITS == "64" ]]
then
    CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS:STRING=-m64"
    CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS:STRING=-m64"
fi

### Paraview general settings
CMAKE_OPTIONS+=" -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_USE_VISITBRIDGE=ON"
CMAKE_OPTIONS+=" -DBUILD_TESTING:BOOL=OFF"

if [ -n "$SAT_HPC" ]
then
    CMAKE_OPTIONS+=" -DPARAVIEW_USE_MPI:BOOL=ON"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpic++"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpicc"
else
    CMAKE_OPTIONS+=" -DPARAVIEW_USE_MPI:BOOL=OFF"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=`which g++`"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=`which gcc`"
fi

### VTK general settings
CMAKE_OPTIONS+=" -DVTK_USE_64BIT_IDS:BOOL=OFF"       # issue 1779
CMAKE_OPTIONS+=" -DVTK_NO_PYTHON_THREADS:BOOL=OFF"  # Make sure Python is thread-safe in ParaView
CMAKE_OPTIONS+=" -DVTK_REPORT_OPENGL_ERRORS:BOOL=OFF"
CMAKE_OPTIONS+=" -DVTK_PYTHON_FULL_THREADSAFE=ON"
### OpenGL2 backend for performance improvment
# https://blog.kitware.com/new-opengl-rendering-in-vtk/ 
#CMAKE_OPTIONS+=" -DVTK_RENDERING_BACKEND=OpenGL2"     
### OpenMP to speed computation of some filters
# https://blog.kitware.com/simple-parallel-computing-with-vtksmptools-2/
# https://blog.kitware.com/accelerated-filters-in-paraview-5/
#CMAKE_OPTIONS+=" -DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP" 

### Qt settings
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_QT_GUI:BOOL=ON"
if [ -n "$QT5_ROOT_DIR" ]
then
    CMAKE_OPTIONS+=" -DPARAVIEW_QT_VERSION=5"
fi

### Python settings
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
if [ -n "$PYTHONHOME" ] 
then
  # with a native python, do not use these options
  CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE:STRING=${PYTHON_ROOT_DIR}/bin/${python_name}"
  CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR:STRING=${PYTHON_ROOT_DIR}/include/${python_name}"
  CMAKE_OPTIONS+=" -DPYTHON_LIBRARY:STRING=${PYTHON_ROOT_DIR}/lib/${python_name}/config/lib${python_name}.so"
fi

### No tcl tk wrap
CMAKE_OPTIONS+=" -DVTK_WRAP_TCL:BOOL=OFF"
CMAKE_OPTIONS+=" -DVTK_WRAP_JAVA:BOOL=OFF"

### HDF5 settings
CMAKE_OPTIONS+=" -DVTK_USE_SYSTEM_HDF5:BOOL=ON"
CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"


### VisIt Database bridge settings
CMAKE_OPTIONS+=" -DPARAVIEW_USE_VISITBRIDGE=ON"

### Boost settings (needed when activating VisIt bridge)
CMAKE_OPTIONS+=" -DBOOST_ROOT=${BOOST_ROOT_DIR}"

### gl2ps settings
CMAKE_OPTIONS+=" -DVTK_USE_SYSTEM_GL2PS:BOOL=ON"
if [ -n "$GL2PS_ROOT_DIR" ] 
then
  # with a native gl2ps, do not use these options
  CMAKE_OPTIONS+=" -DGL2PS_INCLUDE_DIR:STRING=${GL2PS_ROOT_DIR}/include"
  CMAKE_OPTIONS+=" -DGL2PS_LIBRARY:STRING=${GL2PS_ROOT_DIR}/lib/libgl2ps.so"
fi

### libxml2 settings
CMAKE_OPTIONS+=" -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON"
if [ -n "$LIBXML2_ROOT_DIR" ] 
then
  # with a native libxml2, do not use these options
  CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
  CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
  CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

### freetype settings
CMAKE_OPTIONS+=" -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON"
if [ -n "$FREETYPE_ROOT_DIR" ] 
then
  # with a native freetype, do not use these options
  CMAKE_OPTIONS+=" -DFREETYPE_INCLUDE_DIRS:STRING=${FREETYPE_ROOT_DIR}/include/freetype2"
  CMAKE_OPTIONS+=" -DFREETYPE_LIBRARY:STRING=${FREETYPE_ROOT_DIR}/lib/libfreetype.so"
fi

### Extra options since OCC presta to improve Paraview for Salome
CMAKE_OPTIONS+=" -DPARAVIEW_USE_3DGLYPH:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_USE_EXTENDED_OPENFILEDIALOG:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_USE_TIMECONTROL_SLIDER:BOOL=ON"

### Extra options (switch off non-used Paraview plug-ins)
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_Moments:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_PrismPlugin:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SLACTools:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SierraPlotTools:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_PacMan:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_MobileRemoteControl:BOOL=OFF"

### Extra options (switch on required Paraview plug-ins)
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_ForceTime:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_H5PartReader:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_PointSprite:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_SurfaceLIC:BOOL=ON"
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_CATALYST:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=OFF"
CMAKE_OPTIONS+=" -DPARAVIEW_ENABLE_MATPLOTLIB:BOOL=ON"

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

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

cp -f ./VTK/VTKTargets.cmake $PRODUCT_INSTALL/lib/cmake/paraview-5.1/ && \
sed -i "s%\(IMPORTED_LOCATION_RELEASE.*\"\).*/lib/\([^/]\+\"\)%\1${PRODUCT_INSTALL}/lib/paraview-${PVLIBVERSION}/\2%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \
sed -i "s%\(IMPORTED_LOCATION_RELEASE.*\"\).*/bin/\([^/]\+\"\)%\1${PRODUCT_INSTALL}/bin/\2%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \
sed -i "s%[^;\"]\+/qt-[0-9\.]\+/lib/\([^;]\+\)%${QTDIR}/lib/\1%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \
sed -i "s%[^;\"]\+/Python-[0-9\.]\+/lib/\([^;]\+\)%${PYTHON_ROOT_DIR}/lib/\1%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \
sed -i "s%[^;\"]\+/hdf5-[0-9\.]\+/lib/\([^;]\+\)%${HDF5_ROOT_DIR}/lib/\1%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \
sed -i "s%[^;\"]\+/gl2ps-[0-9\.]\+/lib/\([^;]\+\)%${GL2PS_ROOT_DIR}/lib/\1%g" ${PRODUCT_INSTALL}/lib/cmake/paraview-${PVLIBVERSION}/VTKTargets.cmake && \

if [ $? -ne 0 ]
then
    echo "ERROR on cp"
    exit 4
fi

echo
echo "########## END"

