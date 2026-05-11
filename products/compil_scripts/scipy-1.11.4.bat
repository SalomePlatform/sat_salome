@echo off

echo ##########################################################################
echo scipy %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir "%BUILD_DIR%"
cd "%SOURCE_DIR%"
xcopy * "%BUILD_DIR%" /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd "%BUILD_DIR%"

echo.
echo *** %PYTHON_ROOT_DIR:\=/%\python.exe -m pip install --cache-dir=%BUILD_DIR:\=/%/cache/pip ./scipy-1.11.4-cp39-cp39-win_amd64.whl --no-deps --prefix=%PRODUCT_INSTALL%
echo.
mkdir %BUILD_DIR%\cache\pip
set PIP_DISABLE_PIP_VERSION_CHECK=1
%PYTHON_ROOT_DIR:\=/%\python.exe -m pip install --cache-dir=%BUILD_DIR:\=/%/cache/pip ./scipy-1.11.4-cp39-cp39-win_amd64.whl --no-deps --prefix=%PRODUCT_INSTALL% -vvv
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on pip install 
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
