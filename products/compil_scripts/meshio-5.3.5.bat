@echo off

echo ##########################################################################
echo meshio %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%\cache\pip

cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

REM Ensure that meshio is not present.
%PYTHON_ROOT_DIR%\python.exe -m pip uninstall -y meshio

%PYTHON_ROOT_DIR%\python.exe setup.py install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

REM Fix Python path
cd %PYTHONHOME%\Scripts
powershell -Command "(Get-Content  meshio-script.py).replace('%PYTHONBIN%','python3.exe') |Set-Content  meshio-script.py"
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on powershell command.
    exit 3
)

echo.
echo ########## END
