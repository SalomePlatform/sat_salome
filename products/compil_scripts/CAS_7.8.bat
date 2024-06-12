@echo off

echo ##########################################################################
echo CAS %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR% -A x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%

REM TBB
REM set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_TBB:BOOL=ON -D3RDPARTY_TBB_DIR:STRING=%TBB_DIR:\=/%
REM FREETYPE
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_FREETYPE:BOOL=ON -D3RDPARTY_FREETYPE_DIR:STRING=%FREETYPEDIR:\=/%
REM FREEIMAGE
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_FREEIMAGE:BOOL=ON -D3RDPARTY_FREEIMAGE_DIR:STRING=%FREEIMAGEDIR:\=/%

REM no GL2PS
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_GL2PS:BOOL=OFF

REM no TCL/TK
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_TCL=OFF -DBUILD_MODULE_Draw=OFF

REM bos #26509
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
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

echo.
echo *********************************************************************
echo *** installation (data)...
echo *********************************************************************
echo.
xcopy /Q /R /Y /E /H /I %SOURCE_DIR%\data %PRODUCT_INSTALL%\data
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying %SOURCE_DIR%\data to %PRODUCT_INSTALL%\data
    exit 1
)

taskkill /F /IM "mspdbsrv.exe"


if %SAT_DEBUG% == 1 (
    xcopy %PRODUCT_INSTALL%\win64\vc14\bind %PRODUCT_INSTALL%\win64\vc14\bin  /E /I /Q
    xcopy %PRODUCT_INSTALL%\win64\vc14\libd %PRODUCT_INSTALL%\win64\vc14\lib  /E /I /Q
)

echo.
echo ########## END
