@echo off

echo ##########################################################################
echo Scipy %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set INSTALL_LIB=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%
if NOT exist "%INSTALL_LIB%" mkdir %INSTALL_LIB%
set PYTHONPATH=%INSTALL_LIB%;%PYTHONPATH%

cd %SOURCE_DIR%
echo.
FOR /F "delims=" %%i IN ("*.whl") DO (set SCIPY_LIB_WHL=%%~ni%%~xi)
echo.
echo INFO: found Wheel file: %SCIPY_LIB_WHL%

python -m pip install --no-dependencies  --ignore-installed %SCIPY_LIB_WHL% --prefix=%PRODUCT_INSTALL%

if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on pip based Scipy installation"
    exit 1
)

mv %PRODUCT_INSTALL%\lib\site-packages %INSTALL_LIB%\site-packages

echo.
echo "########## END"
