rem @echo off

echo ##########################################################################
echo Pyside %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

set PATH=%JOM_ROOT_DIR%;%PATH%
set CL=/MP%NUMBER_OF_PROCESSORS%
%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL% --build-tests --skip-docs --parallel=%NUMBER_OF_PROCESSORS%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on setup.py install
    exit 1
)

copy /Y %PRODUCT_INSTALL%\Lib\site-packages\PySide2\examples\utils\pyside2_config.py %PRODUCT_INSTALL%\Scripts\pyside2_config.py
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy pyside2_config.py
    exit 1
)

echo.
echo ########## END
