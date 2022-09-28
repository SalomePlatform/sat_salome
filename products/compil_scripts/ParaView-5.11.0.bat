@echo off

echo ##########################################################################
echo ParaView %VERSION% %PYTHON_VERSION% %PYTHON_VERSION:.=%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

set PVLIBVERSION=5.9

set python_name=python%PYTHON_VERSION%

set CMAKE_OPTIONS=
REM common compiler and install settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_VERBOSE_MAKEFILE=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%

REM common ParaView settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_BUILD_SHARED_LIBS:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_TESTING:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON

REM OpenGL settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DOpenGL_GL_PREFERENCE:STRING=LEGACY

REM Ray-tracing settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_ENABLE_RAYTRACING:BOOL=ON 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_ENABLE_OSPRAY:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dospray_DIR:PATH=%OSPRAY_ROOT_DIR:\=/%/lib/cmake/ospray-2.4.0
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dembree_DIR:PATH=%EMBREE_ROOT_DIR:\=/%/lib/cmake/embree-3.12.2

REM Paraview general settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_PYTHON_FULL_THREADSAFE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_PYTHON_VERSION:STRING=3

REM VTK general settings

REM Use 64 bits IDS on request
if DEFINED SALOME_USE_64BIT_IDS (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS%  -DVTK_USE_64BIT_IDS:BOOL=ON
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS%  -DVTK_USE_64BIT_IDS:BOOL=OFF
)

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_INSTALL_LIBRARY_DIR=lib/paraview-%PVLIBVERSION%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_INSTALL_ARCHIVE_DIR=lib/paraview-%PVLIBVERSION%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_PYTHON_SITE_PACKAGES_SUFFIX=site-packages
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTKm_INSTALL_LIB_DIR=lib/paraview-%PVLIBVERSION%

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_REPORT_OPENGL_ERRORS:BOOL=OFF

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_RenderingLOD:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_FiltersCore:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_CommonCore:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_IOCore:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_IOEnSight:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_VTK_IOInfovis:INTERNAL=YES

REM TBB settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dtbb_DIR:PATH=%TBB_ROOT_DIR:\=/%

REM Qt settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_USE_QT:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_BUILD_QT_DESIGNER_PLUGIN:BOOL=OFF

REM Python settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_USE_PYTHON:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_WRAP_PYTHON:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS%  -DPython3_EXECUTABLE:FILEPATH=%PYTHON_ROOT_DIR:\=/%/python3.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_INCLUDE_DIR:FILEPATH=%PYTHON_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_LIBRAY_DIRS=%PYTHON_ROOT_DIR:\=/%/libs
if %SAT_DEBUG% == 0 (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_LIBRARY:FILEPATH=%PYTHON_ROOT_DIR:\=/%/libs/python%PYTHON_VERSION:.=%.lib
) else (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_LIBRARY:FILEPATH=%PYTHON_ROOT_DIR:\=/%/libs/python%PYTHON_VERSION:.=%_d.lib
)
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_PYTHON_FULL_THREADSAFE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_NO_PYTHON_THREADS:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_PYTHON_VERSION:STRING=3
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_WINDOWS_PYTHON_DEBUGGABLE:BOOL=OFF

REM Java settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_WRAP_JAVA:BOOL=OFF

REM MPI settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_USE_MPI:BOOL=OFF

REM HDF5 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_DIR:PATH=%HDF5_ROOT_DIR:\=/%/cmake/hdf5
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_INCLUDE_DIRS:PATH=%HDF5_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF

REM CGNS
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_ParaView_cgns:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_INCLUDE_DIR:PATH=%CGNS_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_LIBRARY:STRING=%CGNS_ROOT_DIR:\=/%/lib/cgnsdll.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_ParaView_cgns:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsCGNSReader:INTERNAL=YES
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsCGNSWriter:INTERNAL=YES

REM VisIt Database bridge settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS%  -DPARAVIEW_ENABLE_VISITBRIDGE:BOOL=ON

REM Boost settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_ROOT:PATH=%BOOST_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_ADDITIONAL_VERSIONS="1.67.0 1.67"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_INCLUDEDIR=%BOOST_ROOT_DIR:\=/%/include/boost-1_67
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_INCLUDE_DIR=%BOOST_ROOT_DIR:\=/%/include/boost-1_67
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_BOOST_CMAKE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_SYSTEM_PATHS:BOOL=ON

REM libxml2 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_INCLUDE_DIR:STRING=%LIBXML2_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARIES:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_XMLLINT_EXECUTABLE=%LIBXML2_ROOT_DIR:\=/%/bin/xmllint.exe

REM gl2ps settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps:BOOL=OFF

REM freetype settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DFREETYPE_INCLUDE_DIRS:PATH=%FREETYPE_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DFREETYPE_INCLUDE_DIR_freetype2:PATH=%FREETYPE_ROOT_DIR:\=/%/include/freetype2
if %SAT_DEBUG% == 0 (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DFREETYPE_LIBRARY:STRING=%FREETYPE_ROOT_DIR:\=/%/lib/freetype.lib
) else (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DFREETYPE_LIBRARY:STRING=%FREETYPE_ROOT_DIR:\=/%/lib/freetyped.lib
)
REM ZLIB settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_INCLUDE_DIR:STRING=%ZLIB_ROOT_DIR:\=/%/include
if %SAT_DEBUG% == 0 (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_LIBRARY:STRING=%ZLIB_ROOT_DIR:\=/%/lib/zlib.lib
) else (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_LIBRARY:STRING=%ZLIB_ROOT_DIR:\=/%/lib/zlibd.lib
)

REM Extra options (switch off non-used Paraview plug-ins)
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGINS_DEFAULT:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGIN_ENABLE_Moments:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGIN_ENABLE_SLACTools:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGIN_ENABLE_SierraPlotTools:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGIN_ENABLE_PacMan:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_PLUGIN_ENABLE_pvblot:BOOL=OFF

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPARAVIEW_USE_CATALYST:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCATALYST_BUILD_STUB_IMPLEMENTATION:BOOL=ON

REM allow additional plugins
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_ALL_NEW_OBJECT_FACTORY:BOOL=ON

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"

cd %BUILD_DIR%
echo.
echo INFO: running command: %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

REM in order to fullfill some prerequistes by GUI!
cd %PRODUCT_INSTALL%\bin
mkdir Lib
MOVE /Y site-packages Lib\site-packages

REM move 
set MSBUILDDISABLENODEREUSE=1

REM In debug mode, we need to rename all .pyd to _d.pyd... don't ask why. Seems like a known bug in OmniORB.
if %SAT_DEBUG% == 1 (
  cd %PRODUCT_INSTALL%\bin\Lib\site-packages
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
)

echo.
echo --------------------------------------------------------------------------
echo *** Post processing
echo --------------------------------------------------------------------------
echo.

echo
echo "########## END"
