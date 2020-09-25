@echo off

echo ##########################################################################
echo swig %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

xcopy . %PRODUCT_INSTALL% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd %PRODUCT_INSTALL%
mkdir %PRODUCT_INSTALL%\bin

mv %PRODUCT_INSTALL%\swig.exe %PRODUCT_INSTALL%\bin\swig.exe
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copy swig.exe
    exit 2
)

echo.
echo ########## END