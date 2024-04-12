@echo off

echo ##########################################################################
echo PyFMI %VERSION%
echo ##########################################################################

SET INSTALL_CENTRALLY=1
REM retrieve the PRODUCT name...
for %%i in (%PRODUCT_INSTALL%) do set "PRODUCT_NAME=%%~nxi"
echo ##########################################################################
echo *** Installing %PRODUCT_NAME% version: %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

if NOT %PYTHON_VERSION% == 3.6 (
	del /Q /S %BUILD_DIR%\src\pyfmi\*.c
)

if %PYTHON_VERSION% == 3.6 (
   COPY /Y %BUILD_DIR%\src\pyfmi\fmi.pyx.3.6.5 %BUILD_DIR%\src\pyfmi\fmi.pyx
)

set INSTALL_LIB=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages
if NOT exist "%INSTALL_LIB%" mkdir %INSTALL_LIB%
set PYTHONPATH=%INSTALL_LIB%;%PYTHONPATH%

echo.
echo ##########################################################################
echo *** Launching python.exe setup.py build
echo ##########################################################################

%PYTHON_ROOT_DIR%\python.exe setup.py build --build-base %BUILD_DIR% --build-temp %BUILD_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py build
    exit 1
)

echo.
echo ##########################################################################
echo *** Launching python.exe setup.py install
echo ##########################################################################

SET SETUP_EXTRA_OPTIONS=--old-and-unmanageable
if %PYTHON_VERSION% == 3.6 (
  SET SETUP_EXTRA_OPTIONS=
)

if %INSTALL_CENTRALLY% == 1 (
    %PYTHON_ROOT_DIR%\python.exe setup.py install %SETUP_EXTRA_OPTIONS%
) else (
    %PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL% --install-lib=%INSTALL_LIB%  %SETUP_EXTRA_OPTIONS%
)

if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py install
    exit 2
)
if %INSTALL_CENTRALLY% == 1 (
    @echo off
    @echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
    @echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt
)

echo.
echo ########## END

