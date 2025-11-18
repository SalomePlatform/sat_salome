@echo off

echo ##########################################################################
echo scipy %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir "%BUILD_DIR%"
cd "%SOURCE_DIR%"
xcopy * "%BUILD_DIR%" /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd "%BUILD_DIR%"

echo.
echo Lapack is embedded. Expose it to Scipy

echo [DEFAULT] > site.cfg
echo library_dirs = %OPENBLASHOME:\=/%/lib>> site.cfg
echo include_dirs = %OPENBLASHOME:\=/%/include>> site.cfg
echo. >> site.cfg
echo [blas]>> site.cfg
echo libraries = openblas>>site.cfg
echo. >> site.cfg
echo [lapack]>> site.cfg
echo libraries = openblas>>site.cfg
echo. >> site.cfg
echo [numpy]>> site.cfg
echo include_dirs = %NUMPY_INCLUDE_DIR2:\=/%>> site.cfg

set PATH=%PATH%;%MINGW_ROOT_DIR%\bin
set FC=%MINGW_ROOT_DIR%\bin\gfortran.exe

echo.
echo *** %PYTHON_ROOT_DIR:\=/%\python.exe -m pip install --cache-dir=%BUILD_DIR:\=/%/cache/pip . --no-binary :all: --no-build-isolation --prefix=%PRODUCT_INSTALL:\=/%
echo.
mkdir %BUILD_DIR%\cache\pip
%PYTHON_ROOT_DIR:\=/%\python.exe -m pip install --cache-dir=%BUILD_DIR:\=/%/cache/pip . --no-binary :all: --no-build-isolation --prefix=%PRODUCT_INSTALL:\=/% -vvv
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on pip install 
    exit 3
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
