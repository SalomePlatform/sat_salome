@echo off

echo ##########################################################################
echo zlib (binary) %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

xcopy include %PRODUCT_INSTALL%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 1
)

xcopy bin %PRODUCT_INSTALL%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy bin
    exit 2
)

echo.
echo ########## END
