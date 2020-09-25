#!/bin/bash

echo "##########################################################################"
echo "VTK" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

python_name=python$PYTHON_VERSION

sed -i "s%seekg(self->GetFile()->tellg()%seekg(static_cast<long>(self->GetFile()->tellg())%g" IO/vtkBMPReader.cxx
sed -i "s%seekg(self->GetFile()->tellg()%seekg(static_cast<long>(self->GetFile()->tellg())%g" IO/vtkImageReader.cxx
sed -i "s%#include <string>%#include <string>\n#include <cstring>%g" Utilities/DICOMParser/DICOMFile.cxx
sed -i "s%#include <string>%#include <string>\n#include <cstring>%g" Utilities/DICOMParser/DICOMParser.cxx
sed -i "s%#include <string>%#include <string>\n#include <cstring>%g" Utilities/DICOMParser/DICOMAppHelper.cxx

chmod 600 Utilities/vtktiff/tif_fax3sm.c

#sed -i "s%char \*doc \=%const char \*doc \=%g" Common/vtkPythonUtil.cxx

VTK_CMAKE_OPTIONS=""
### compiler options
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS"-DVTK_HAVE_GETSOCKNAME_WITH_SOCKLEN_T=1"
### common VTK settings
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DBUILD_SHARED_LIBS:BOOL=ON"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DCMAKE_BUILD_TYPE:STRING=Release"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DCMAKE_CXX_COMPILER:STRING=`which g++`"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DCMAKE_C_COMPILER:STRING=`which gcc`"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_HYBRID:BOOL=ON"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_PARALLEL:BOOL=ON"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_PATENTED:BOOL=OFF"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_RENDERING:BOOL=ON"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_GL2PS:BOOL=ON"  # GL_2_PS
### Wrap Python settings
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_WRAP_PYTHON:BOOL=ON"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DPYTHON_EXECUTABLE:STRING=${PYTHONHOME}/bin/${python_name}"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DPYTHON_INCLUDE_PATH:STRING=${PYTHONHOME}/include/${python_name}"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DPYTHON_LIBRARY:STRING=${PYTHONHOME}/lib/${python_name}/config/lib${python_name}.a"
### No tcl tk wrap
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_WRAP_TCL:BOOL=OFF"
VTK_CMAKE_OPTIONS=$VTK_CMAKE_OPTIONS" -DVTK_USE_TK:BOOL=OFF"

echo
echo "*** cmake" ${VTK_CMAKE_OPTIONS} 
cmake ${VTK_CMAKE_OPTIONS} .
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
echo "*** create links"
cd ${PRODUCT_INSTALL}/include
ln -s vtk-${VERSION%.*}/ vtk
cd ${PRODUCT_INSTALL}/lib
ln -s . vtk

echo
echo "########## END"

