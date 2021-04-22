@echo off

echo ##########################################################################
echo ispc %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

SET MSBUILDDISABLENODEREUSE=1
cd %SOURCE_DIR%\bin
xcopy * %PRODUCT_INSTALL%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

echo.
echo ########## END
