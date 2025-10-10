@echo off

echo ##########################################################################
echo BOOST %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
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

.\bjam --toolset=msvc --prefix=%PRODUCT_INSTALL% address-model=%PLATFORM_TARGET%  --build-type=complete stage variant=%PRODUCT_BUILD_TYPE% threading=multi link=shared runtime-link=shared install

cd "%BUILD_DIR%"

MOVE /Y %PRODUCT_INSTALL%\include\boost\boost-1_67 %PRODUCT_INSTALL%\include\boost
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying include
    exit 31
)

echo.
echo ########## END
