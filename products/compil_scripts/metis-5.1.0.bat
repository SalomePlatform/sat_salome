@echo off

echo ##########################################################################
echo Metis %VERSION%
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

REM ensure that the installation directory does exist
if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %BUILD_DIR%

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR% -A x64

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
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

xcopy /y /e /q programs\%PRODUCT_BUILD_TYPE% %PRODUCT_INSTALL%\bin
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying binaries
    exit 3
)

xcopy /y /e /q libmetis\%PRODUCT_BUILD_TYPE% %PRODUCT_INSTALL%\lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying lib
    exit 4
)

xcopy /y /e /q include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying include
    exit 5
)

copy %SOURCE_DIR%\include\metis.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying include
    exit 6
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END

