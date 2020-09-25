@echo off

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

set INSTALL_LIB=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages
if NOT exist "%INSTALL_LIB%" mkdir %INSTALL_LIB%
set PYTHONPATH=%INSTALL_LIB%;%PYTHONPATH%

echo.
echo ##########################################################################
echo *** Launching "python.exe setup.py build"
echo ##########################################################################

%PYTHON_ROOT_DIR%\python.exe setup.py build --build-base %BUILD_DIR% --build-temp %BUILD_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py build
    exit 1
)

echo.
echo ##########################################################################
echo *** Launching "python.exe setup.py install"
echo ##########################################################################

if %INSTALL_CENTRALLY% == 1 (
    %PYTHON_ROOT_DIR%\python.exe setup.py install
) else (
    %PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL% --install-lib=%INSTALL_LIB% 
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

