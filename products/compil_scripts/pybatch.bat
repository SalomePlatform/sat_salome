@echo off

echo ##########################################################################
echo pybatch %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%\cache\pip

cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

REM Ensure that pybatch is not present.
%PYTHON_ROOT_DIR%\python.exe -m pip uninstall -y pybatch

%PYTHON_ROOT_DIR%\python.exe setup.py install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

REM RUN TESTS
REM xcopy %SOURCE_DIR%\conftest.py %PRODUCT_INSTALL%\conftest.py /E /I /Q
REM xcopy %SOURCE_DIR%\tests %PRODUCT_INSTALL%\tests /E /I /Q

%PYTHON_ROOT_DIR%\python.exe -m pytest %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on non regression tests
    exit 4
)
echo.
echo ########## END
