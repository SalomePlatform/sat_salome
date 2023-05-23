@echo off

echo ##########################################################################
echo openturns %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

REM we don't install in python directory -> modify environment as described in INSTALL file
set PATH=%WINFLEX_ROOT_DIR%;%PATH%
SET PATH=%CWD%\bin;%PATH%
SET PYTHONPATH=%CWD%;%PYTHONPATH%
SET PYTHONPATH=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages;%PYTHONPATH%

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_EXECUTABLE=%SWIG_ROOT_DIR:\=/%/bin/swig
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_ROOT_DIR=%TBB_ROOT_DIR%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dtbb_DIR:PATH=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_TBB=OFF
REM libxml2 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_INCLUDE_DIR:STRING=%LIBXML2_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARIES:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_XMLLINT_EXECUTABLE=%LIBXML2_ROOT_DIR:\=/%/bin/xmllint.exe

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

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
mkdir openturns
mkdir cache
mkdir cache\pip

cd  %BUILD_DIR%\openturns

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%\openturns-1.20.1
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake -G "Visual Studio 15 2017 Win64" %CMAKE_OPTIONS% %SOURCE_DIR%\openturns-1.20.1
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj

echo *********************************************************************
echo.

REM ON PURPOSE, we CONTINUE if fails since the error are about porting some NR to Windows native build (openturns team uses mingw)
msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj, please check!
    REM exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo
echo "########## END"