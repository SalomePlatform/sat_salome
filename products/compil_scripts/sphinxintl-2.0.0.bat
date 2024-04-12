@echo off

echo ##########################################################################
echo sphinxintl %VERSION%
echo ##########################################################################

REM install in python directly
SET INSTALL_CENTRALLY=1

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe setup.py build"
echo --------------------------------------------------------------------------
set BUILD_OPT=
if %SAT_DEBUG% == 1 (
   set BUILD_OPT=--debug
)

%PYTHON_ROOT_DIR%\python.exe setup.py build %BUILD_OPT%

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe setup.py install"
echo --------------------------------------------------------------------------
SET SETUP_EXTRA_OPTIONS=--old-and-unmanageable
if %PYTHON_VERSION% == 3.6 (
	SET SETUP_EXTRA_OPTIONS=
)

if %INSTALL_CENTRALLY% == 1 (
    %PYTHONBIN% setup.py  build  %BUILD_OPT% install %SETUP_EXTRA_OPTIONS%
) else (
    %PYTHONBIN% setup.py build  %BUILD_OPT% install --prefix=%PRODUCT_INSTALL% %SETUP_EXTRA_OPTIONS%
)
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on sphinxintl
  exit 1
)

if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py install 
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
