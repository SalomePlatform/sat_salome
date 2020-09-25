@echo off

echo ##########################################################################
echo sip %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

set python_name=python%PYTHON_VERSION%

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe configure.py"
echo --------------------------------------------------------------------------

%PYTHON_ROOT_DIR%\python.exe configure.py -b %PRODUCT_INSTALL%\bin -d %PRODUCT_INSTALL%\lib\%python_name%\site-packages -e %PRODUCT_INSTALL%\include\%python_name% -v %PRODUCT_INSTALL%\sip -p win32-msvc
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on python configure.py "
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo Launching "nmake"
echo --------------------------------------------------------------------------

nmake
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake"
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo Launching "nmake install"
echo --------------------------------------------------------------------------

nmake install
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 3
)

echo.
echo ########## END
