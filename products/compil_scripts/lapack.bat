@echo off

echo ##########################################################################
echo Installing Lapack %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

set PLATFORM_TARGET=x64
if "%SALOME_APPLICATION_NAME%" == "URANIE" (
  set PLATFORM_TARGET=x86
)

set GFORTRAN_ROOT_DIR=%MINGW_ROOT_DIR%
if %PLATFORM_TARGET% == x86 (
  set GFORTRAN_ROOT_DIR=%MINGW_32BIT_ROOT_DIR%
)

set GFORTRAN_EXE=%GFORTRAN_ROOT_DIR%\bin\gfortran.exe

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

echo.
echo ************************************************
echo *** Setting local path to %GFORTRAN_ROOT_DIR%\bin
echo ************************************************
set path=%GFORTRAN_ROOT_DIR%\bin;%path%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_OPTIMIZED_BLAS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCBLAS=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLAPACKE=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=%GFORTRAN_ROOT_DIR:\=/%/bin/gfortran.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SH="CMAKE_SH-NOTFOUND"

if %PLATFORM_TARGET% == x64 (
  goto :SET_CMAKE_64_BIT_SECTION
)
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_FLAGS="-fPIC -m32"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_FLAGS="-fPIC -m32"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition -m32"
goto :SET_CMAKE_END

:SET_CMAKE_64_BIT_SECTION
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_FLAGS="-fPIC"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_FLAGS="-fPIC"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition"

:SET_CMAKE_END
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="MinGW Makefiles"
set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** cmake %CMAKE_OPTIONS%  %SOURCE_DIR%
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
