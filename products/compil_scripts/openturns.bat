@echo off

echo ##########################################################################
echo ROOT %VERSION%
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
cd %BUILD_DIR%
set path=%MINGW_ROOT_DIR%\bin;%path%
set CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHON_ROOT_DIR:\=/%/python.exe
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLAPACK_LIBRARIES=%LAPACK_ROOT_DIR:\=/%/lib/liblapack.dll
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBLAS_LIBRARIES=%LAPACK_ROOT_DIR:\=/%/lib/libblas.dll
REM SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SIZEOF_VOID_P=8
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/gfortran.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SH="CMAKE_SH-NOTFOUND"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="MinGW Makefiles"

cd %BUILD_DIR%

echo.
echo *********************************************************************
echo *** cmake %CMAKE_OPTIONS}%
echo *********************************************************************
%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** mingw32-make
echo *********************************************************************
echo.
mingw32-make
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make
    exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.
mingw32-make install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make install
    exit 3
)




REM echo.
REM echo --------------------------------------------------------------------------
REM echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
REM echo --------------------------------------------------------------------------

REM %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
REM if NOT %ERRORLEVEL% == 0 (
    REM echo ERROR on CMake
    REM exit 1
REM )

REM echo.
REM echo --------------------------------------------------------------------------
REM echo *** msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
REM echo --------------------------------------------------------------------------

REM msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64
REM if NOT %ERRORLEVEL% == 0 (
    REM echo ERROR on msbuild ALL_BUILD.vcxproj
    REM exit 2
REM )

REM echo.
REM echo --------------------------------------------------------------------------
REM echo *** msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
REM echo --------------------------------------------------------------------------

REM msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=x64
REM if NOT %ERRORLEVEL% == 0 (
    REM echo ERROR on msbuild INSTALL.vcxproj
    REM exit 3
REM )

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
