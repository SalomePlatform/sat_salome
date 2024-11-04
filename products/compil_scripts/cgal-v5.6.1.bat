@echo off

echo ##########################################################################
echo cgal %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET PRODUCT_BUILD_TYPE=release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CGAL_DISABLE_GMP=1
cd %BUILD_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -A x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_examples=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_tests=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_demos=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGAL_ENABLE_TESTING=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGAL_USE_GMP=OFF

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake
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

echo ********************************************************************
echo Building cgal_test
echo ********************************************************************

REM clean BUILD directory
mkdir %BUILD_DIR%\cgal_test
cd %BUILD_DIR%\cgal_test

set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%BUILD_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -A x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGAL_DIR=%PRODUCT_INSTALL:\=/%/lib/cmake
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DEXECUTABLE_OUTPUT_PATH=%BUILD_DIR:\=/%/bin
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCGAL_DISABLE_GMP=OFF

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%\cgal_test
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake cgal_test
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

REM Install the executable into the common directory
if NOT exist "%SINGLE_INSTALL_DIR%" mkdir %SINGLE_INSTALL_DIR%
if NOT exist "%SINGLE_INSTALL_DIR%\bin" mkdir %SINGLE_INSTALL_DIR%\bin
copy /B /Y %BUILD_DIR%\bin\%PRODUCT_BUILD_TYPE%\exec_cgal.exe %SINGLE_INSTALL_DIR%\bin\exec_cgal.exe
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy exec_cgal.exe to %SINGLE_INSTALL_DIR%\bin
    exit 2
)

echo.
echo exec_cgal version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %SINGLE_INSTALL_DIR%\bin >> %PRODUCT_INSTALL%\README.txt

echo
echo ########## END
