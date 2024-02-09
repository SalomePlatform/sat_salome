@echo off

echo ##########################################################################
echo DXF
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

xcopy %SOURCE_DIR% %PRODUCT_INSTALL% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy dxf
    exit 1
)

echo.
echo ########## END
