@echo off

echo ##########################################################################
echo alabaster %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

set dir_lib=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages
if NOT exist "%dir_lib%" mkdir %dir_lib%
set PYTHONPATH=%dir_lib%;%PYTHONPATH%

echo.
echo --------------------------------------------------------------------------
echo *** Launching "python.exe setup.py build"
echo --------------------------------------------------------------------------

%PYTHON_ROOT_DIR%\python.exe setup.py build --build-base %BUILD_DIR% --build-temp %BUILD_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py build
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** Launching "python.exe setup.py install"
echo --------------------------------------------------------------------------

%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL% --install-lib=%dir_lib% 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py install
    exit 3
)

echo.
echo ########## END
