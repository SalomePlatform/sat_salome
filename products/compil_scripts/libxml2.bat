@echo off

echo ##########################################################################
echo libxml2 %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%"\include mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

SET ROOT_DIR=%CD%

cd %ROOT_DIR%\win32

echo.
echo --------------------------------------------------------------------------
echo *** cscript configure.js compiler=msvc prefix=%PRODUCT_INSTALL% iconv=no
echo --------------------------------------------------------------------------

cscript configure.js compiler=msvc prefix=%PRODUCT_INSTALL% iconv=no
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on configure
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake /f Makefile.msvc
echo --------------------------------------------------------------------------

nmake /f Makefile.msvc
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake install /f Makefile.msvc
echo --------------------------------------------------------------------------

nmake install /f Makefile.msvc
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake install
    exit 3
)

echo.
echo --------------------------------------------------------------------------
echo *** Post-installation
echo --------------------------------------------------------------------------

move %PRODUCT_INSTALL%\include\libxml2\libxml %PRODUCT_INSTALL%\include\libxml

echo.
echo ########## END
