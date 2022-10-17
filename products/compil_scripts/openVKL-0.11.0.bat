@echo off

echo ##########################################################################
echo openVKL %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM Building openVKL in DEBUG mode is definitely not relevant.
if %SAT_DEBUG% == 1 (
   set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%


SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dembree_DIR:PATH=%EMBREE_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_PATH=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Drkcommon_DIR=%rkcommon_DIR/\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_TESTING=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR=lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_EXAMPLES=OFF
SET CMAKE_OPYIONS=%CMAKE_OPTIONS% -DBUILD_TBB=OFF
SET CMAKE_OPYIONS=%CMAKE_OPTIONS% -DBUILD_RKCOMMON=OFF
SET CMAKE_OPYIONS=%CMAKE_OPTIONS% -DBUILD_EMBREE=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DRKCOMMON_TBB_ROOT=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
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
echo *** msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
