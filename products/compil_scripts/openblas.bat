@echo off

echo ##########################################################################
echo Installing OpenBLAS %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
REM if %SAT_DEBUG% == 1 (
REM   set PRODUCT_BUILD_TYPE=Debug
REM )

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set GFORTRAN_EXE=%MINGW_ROOT_DIR%\bin\gfortran.exe

echo.
echo ************************************************
echo *** Setting local path to %MINGW_ROOT_DIR%\bin
echo ************************************************
set path=%MINGW_ROOT_DIR%\bin;%path%
set CMAKE_OPTIONS=%SOURCE_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_FLAGS=-fPIC
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_FLAGS=-fPIC
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_OPTIMIZED_BLAS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCBLAS=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLAPACKE=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SIZEOF_VOID_P=8
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/gfortran.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SH="CMAKE_SH-NOTFOUND"
if defined CMAKE_GENERATOR (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="MinGW Makefiles"
)
set MSBUILDDISABLENODEREUSE=1

echo.
echo *** cmake %CMAKE_OPTIONS}%
%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)
echo.
echo *********************************************************************
echo *** mingw32-make"
echo *********************************************************************
echo.

mingw32-make
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.
mingw32-make install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)


