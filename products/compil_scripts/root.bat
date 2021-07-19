@echo off

echo ##########################################################################
echo root %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release

REM TODO: NGH: not Tested yet
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -A Win32 -Thost=x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_STANDARD=14 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_fftw3=OFF 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_LIBRARY_DIRS=%PYTHON_ROOT_DIR%\libs
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dpyroot=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dpyroot_legacy=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dminuit2=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_freetype=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_davix=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_ftgl=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_gl2ps=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_glew=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_gsl=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_lz4=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_lzma=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_pcre=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_unuran=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_xxhash=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_zlib=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dbuiltin_zstd=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dmathmore=OFF
rem set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_ROOT:PATH=%BOOST_ROOT_DIR:\=/%
rem set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_ADDITIONAL_VERSIONS="1.67.0 1.67"
rem set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_INCLUDEDIR=%BOOST_ROOT_DIR:\=/%/include/boost-1_67
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SYSTEM_VERSION=10.0.19041.0
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%

cd %BUILD_DIR%
SET INCLUDE=
set PATH=%BUILD_DIR%\bin;%PATH%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on root
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x86 ALL_BUILD.vcxproj
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x86 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo. 
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x86 INSTALL.vcxproj
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x86 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo.
echo ########## END
