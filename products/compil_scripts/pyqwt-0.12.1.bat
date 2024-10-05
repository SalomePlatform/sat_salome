@echo off

echo ##########################################################################
echo pyqwt %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%\cache\pip

cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

REM Ensure that meshio is not present.
%PYTHON_ROOT_DIR%\python.exe -m pip uninstall -y pyqwt

%PYTHON_ROOT_DIR%\python.exe -m pip install . --cache-dir=%BUILD_DIR%\cache\pip --no-deps --no-build-isolation
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python -m pip install
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
