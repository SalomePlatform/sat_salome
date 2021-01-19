@echo off

echo ##########################################################################
echo BOOST %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=release

REM TODO: NGH: not Tested yet
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

call bootstrap.bat

echo.
echo --------------------------------------------------------------------------
echo *** Compilation
echo --------------------------------------------------------------------------
.\bjam --toolset=msvc --prefix=%PRODUCT_INSTALL% address-model=64  --build-type=complete stage variant=%PRODUCT_BUILD_TYPE% threading=multi link=shared runtime-link=shared install

cd "%BUILD_DIR%"

MOVE /Y %PRODUCT_INSTALL%\include\boost\boost-1_67 %PRODUCT_INSTALL%\include\boost
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying include
    exit 31
)

echo.
echo ########## END
