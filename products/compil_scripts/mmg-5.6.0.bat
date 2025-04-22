@echo off

echo ##########################################################################
echo mmg %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
mkdir %PRODUCT_INSTALL%\bin

cd %SOURCE_DIR%
xcopy %SOURCE_DIR%\*.exe %PRODUCT_INSTALL%\bin /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

echo.
echo ########## END
