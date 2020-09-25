@echo off

set INSTALL_CENTRALLY=1
for %%i in (%PRODUCT_INSTALL%) do set "PRODUCT_NAME=%%~nxi"

echo ##########################################################################
echo *** Installing %PRODUCT_NAME% version: %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

echo.
set PRODUCT_WHL=
FOR /F "delims=" %%i IN ('dir /s /b') DO (set PRODUCT_WHL=%%~ni%%~xi)

echo.
echo INFO: found file: %PRODUCT_WHL%

if %INSTALL_CENTRALLY% == 1 (
    echo INFO: running command: %PYTHON_ROOT_DIR%\python.exe -m pip  install --no-dependencies  %PRODUCT_WHL%
    @echo off
    @echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
    @echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt
    %PYTHON_ROOT_DIR%\python.exe -m pip install --no-dependencies  %PRODUCT_WHL%
) else (
    echo INFO: running command: %PYTHON_ROOT_DIR%\python.exe -m pip install  %PRODUCT_WHL% --prefix=%PRODUCT_INSTALL%
    %PYTHON_ROOT_DIR%\python.exe -m pip install  --no-dependencies %PRODUCT_WHL% --prefix=%PRODUCT_INSTALL%
)

if NOT %ERRORLEVEL% == 0 (
    echo ERROR pip install
    exit 1
)

echo.
echo ########## END

