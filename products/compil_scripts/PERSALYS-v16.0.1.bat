@echo off

echo ##########################################################################
echo openturns %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_EXECUTABLE=%SWIG_ROOT_DIR:\=/%/bin/swig.exe
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_ROOT_DIR=%TBB_ROOT_DIR%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dtbb_DIR:PATH=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_TBB=OFF
REM libxml2 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_INCLUDE_DIR:STRING=%LIBXML2_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARIES:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARY:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_XMLLINT_EXECUTABLE=%LIBXML2_ROOT_DIR:\=/%/bin/xmllint.exe


set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_ROOT_DIR=%PTHREAD_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_INCLUDE_DIR=%PTHREAD_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_DLL_LIBRARY=%PTHREAD_ROOT_DIR:\=/%/lib/pthreadVC2.dll
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_LIBRARY=%PTHREAD_ROOT_DIR:\=/%/lib/pthreadVCE2.lib

REM HDF5 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_DIR:PATH=%HDF5_ROOT_DIR:\=/%/cmake/hdf5
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_INCLUDE_DIRS:PATH=%HDF5_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_INCLUDE_DIRS:STRING=%NLOPT_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_LIBRARIES:STRING=%NLOPT_ROOT_DIR:\=/%/bin
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_DIR:STRING=%NLOPT_ROOT_DIR:\=/%

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCBLAS_DIR=%OPENBLAS_ROOT_DIR:\=/%/share/cmake/OpenBLAS

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_EXECUTABLE:FILEPATH=%PYTHON_ROOT_DIR:\=/%/python3.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_INCLUDE_DIR:PATH=%PYTHON_ROOT_DIR:\=/%/include

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLAPACK_LIBRARIES:FILEPATH=%OPENBLAS_ROOT_DIR:\=/%/lib/openblas.lib  
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SHARED_LINKER_FLAGS_RELEASE="/OPT:NOREF /INCREMENTAL:NO" 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_UNITY_BUILD=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_UNITY_BUILD_BATCH_SIZE=16 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_COMPILE_FLAGS="/bigobj"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_SPHINX=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DQWT_INCLUDE_DIR=%QWT_ROOT_DIR:\=/%/include
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DADAO_ROOT_DIR=%ADAO_ROOT_DIR:\=/%

REM Boost settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_ROOT:PATH=%BOOST_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_ADDITIONAL_VERSIONS="1.67.0 1.67"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_INCLUDEDIR=%BOOST_ROOT_DIR:\=/%/include/boost-1_67
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_INCLUDE_DIR=%BOOST_ROOT_DIR:\=/%/include/boost-1_67
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_BOOST_CMAKE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_SYSTEM_PATHS:BOOL=ON

SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DGUI_ROOT_DIR=%GUI_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSalomeGUI_DIR=%GUI_ROOT_DIR:\=/%/adm_local/cmake_files
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DKERNEL_ROOT_DIR=%KERNEL_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSalomeKERNEL_DIR=%KERNEL_ROOT_DIR:\=/%/salome_adm/cmake_files
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DOpenTURNS_DIR=%OT_ROOT_DIR:\=/%/lib/cmake/openturns
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dotmorris_DIR==%OT_ROOT_DIR:\=/%/lib/cmake/otmorris
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPy2cpp_DIR=%PY2CPP_ROOT_DIR:\=/%/lib/cmake/py2cpp

SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DQWT_INCLUDE_DIR=%QWT_ROOT_DIR:\=/%/include
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DQWT_LIBRARY=%QWT_ROOT_DIR:\=/%/lib/qwt.lib

SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_SPHINX=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSPHINX_ROOT_DIR=%SPHINX_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DYACS_ROOT_DIR=%YACS_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSalomeYACS_DIR=%YACS_ROOT_DIR:\=/%/adm/cmake
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dydefx_DIR=%YDEFX_ROOT_DIR:\=/%/salome_adm/cmake_files
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DAdaoCppLayer_INCLUDE_DIR=%ADAO_INTERFACE_ROOT_DIR:\=/%/include
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DAdaoCppLayer_ROOT_DIR=%ADAO_INTERFACE_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_SALOME=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_ROOT=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_INCLUDE_DIR=%TBB_ROOT_DIR:\=/%/include
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_INCLUDE_DIR=%PYTHON_INCLUDE:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_FIND_ROOT_PATH=ON

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_INCLUDE_DIR:PATH=%CGNS_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_LIBRARY:STRING=%CGNS_ROOT_DIR:\=/%/lib/cgnsdll.lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_INCLUDE_DIR:PATH=%CGNS_ROOT_DIR:\=/%/include


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake -G %CMAKE_GENERATOR% -A x64 %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 /p:CharacterSet=Unicode ALL_BUILD.vcxproj

echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 /p:CharacterSet=Unicode ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj, please check!
    REM exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 /p:CharacterSet=Unicode INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo
echo "########## END"
