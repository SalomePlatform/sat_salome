@echo off

echo ##########################################################################
echo med %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_STATIC_LIBS:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ROOT_DIR:STRING=%HDF5_ROOT_DIR%

if DEFINED SALOME_USE_64BIT_IDS (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMED_MEDINT_TYPE:STRING="long long"
)

if DEFINED SAT_HPC (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_USE_MPI:BOOL=ON
) else (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_USE_MPI:BOOL=OFF
)

if defined CMAKE_GENERATOR (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on CMake
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

REM rename documentation directory
cd  %PRODUCT_INSTALL%\share\doc
mv med-fichier* med

taskkill /F /IM "mspdbsrv.exe"


echo.
echo ########## END
