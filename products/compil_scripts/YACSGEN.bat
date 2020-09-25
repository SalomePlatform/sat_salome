@echo off

echo ##########################################################################
echo YACSGEN %VERSION%
echo ##########################################################################


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

echo  *** build in SOURCE directory
cd %SOURCE_DIR%


REM we don't install in python directory -> modify environment as described in INSTALL file
mkdir %PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%
set INSTALL_LIB=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages
if NOT exist "%INSTALL_LIB%" mkdir %INSTALL_LIB%
set PYTHONPATH=%INSTALL_LIB%;%PYTHONPATH%

set PYTHONPATH=%PYTHONPATH%;%PYTHON_ROOT_DIR%
echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe setup.py install"
echo --------------------------------------------------------------------------

%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL% --install-lib=%INSTALL_LIB% 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py install --prefix=%PRODUCT_INSTALL% --install-lib=%INSTALL_LIB% 
    exit 1
)

echo.
echo YACSGEN installed in %PYTHON_ROOT_DIR% > %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
