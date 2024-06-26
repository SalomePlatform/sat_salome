@echo off

echo ##########################################################################
echo BOOST %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)

SET PRODUCT_BUILD_TYPE=release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q /Y
cd %BUILD_DIR%

set VC_VERSION=vc141

call bootstrap.bat %VC_VERSION%

echo.
echo --------------------------------------------------------------------------
echo *** Compilation
echo --------------------------------------------------------------------------

set PLATFORM_TARGET=64
if "%SALOME_APPLICATION_NAME%" == URANIE (
  set PLATFORM_TARGET=32
)

.\b2 --help

.\b2 --prefix=%PRODUCT_INSTALL% address-model=%PLATFORM_TARGET%  --build-type=complete stage variant=%PRODUCT_BUILD_TYPE% threading=multi link=shared runtime-link=shared install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR running b2
    exit 1
)


echo.
echo ########## END
