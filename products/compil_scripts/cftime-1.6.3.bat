@echo off

echo ##########################################################################
echo cftime %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%\cache\pip

cd %BUILD_DIR%

set HDF5_DIR=%HDF5_ROOT_DIR%
set HDF5_INCDIR=%HDF5_INCLUDE_DIRS%
set HDF5_LIBDIR=%HDF5_LIBRARIES%
set NETCDF4_DIR=%NETCDF_ROOT_DIR%
set NETCDF4_INCDIR=%NETCDF_ROOT_DIR%\include
set NETCDF4_LIBDIR=%NETCDF_ROOT_DIR%\lib

xcopy %SOURCE_DIR%\* %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd %BUILD_DIR%
%PYTHON_ROOT_DIR%\python.exe setup.py install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install cftime-1.6.3
    exit 2
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
