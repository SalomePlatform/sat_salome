@echo off

echo ##########################################################################
echo jom %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

cd %SOURCE_DIR%
xcopy * %PRODUCT_INSTALL% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy JOM
    exit 1
)

echo.
echo ########## END
