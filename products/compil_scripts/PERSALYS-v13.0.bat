@echo off

echo ##########################################################################
echo hdf5 %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DADAO_ROOT_DIR=%ADAO_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_ROOT:PATH=%BOOST_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DGUI_ROOT_DIR=%GUI_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSalomeGUI_DIR=%GUI_ROOT_DIR:\=/%/adm_local/cmake_files
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DKERNEL_ROOT_DIR=%KERNEL_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSalomeKERNEL_DIR=%KERNEL_ROOT_DIR:\=/%/salome_adm/cmake_files
REM SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DOpenTURNS_DIR=$OT_ROOT_DIR/lib/cmake/openturns
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPy2cpp_DIR=%PY2CPP_ROOT_DIR:\=/%/lib/cmake/py2cpp
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DQWT_INCLUDE_DIR=%QWT_ROOT_DIR:\=/%/include
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
REM CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE:PATH=$(which swig)"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGNS_INCLUDE_DIR:PATH=%CGNS_ROOT_DIR:\=/%/include

if defined CMAKE_GENERATOR (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)

set MSBUILDDISABLENODEREUSE=1

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on CMake
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

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END


