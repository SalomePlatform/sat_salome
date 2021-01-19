@echo off

echo ##########################################################################
echo sip %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

set python_name=python%PYTHON_VERSION%

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe configure.py"
echo --------------------------------------------------------------------------

if %SAT_DEBUG% == 1 (
  %PYTHON_ROOT_DIR%\python_d.exe %SOURCE_DIR%\configure.py --debug -b %PRODUCT_INSTALL%\bin -d %PRODUCT_INSTALL%\lib\%python_name%\site-packages -e %PRODUCT_INSTALL%\include\%python_name% -v %PRODUCT_INSTALL%\sip -p win32-msvc
) else (
  %PYTHON_ROOT_DIR%\python.exe configure.py -b %PRODUCT_INSTALL%\bin -d %PRODUCT_INSTALL%\lib\%python_name%\site-packages -e %PRODUCT_INSTALL%\include\%python_name% -v %PRODUCT_INSTALL%\sip -p win32-msvc
)

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
