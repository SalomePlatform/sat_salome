@echo off

echo ##########################################################################
echo Installing HOMARD %VERSION%
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
REM
set MEDFILE_SOURCE_DIR=%SOURCE_DIR:HOMARD=medfile%
SET MEDFILE_BUILD_DIR=%BUILD_DIR%\BUILD\MEDFILE
set MEDFILE_INSTALL_DIR=%BUILD_DIR%\W64\medfile
REM
SET HOMARD_BUILD_DIR=%BUILD_DIR%\BUILD\HOMARD
SET HOMARD_GUI_BUILD_DIR=%HOMARD_BUILD_DIR%\GUI
SET HOMARD_TOOL_SOURCE_DIR=%SOURCE_DIR%\src\tool
SET HOMARD_TOOL_BUILD_DIR=%HOMARD_BUILD_DIR%\tool

mkdir %MEDFILE_BUILD_DIR%
mkdir %MEDFILE_INSTALL_DIR%
mkdir %HOMARD_BUILD_DIR%
mkdir %HOMARD_TOOL_BUILD_DIR%
mkdir %HOMARD_GUI_BUILD_DIR%

echo.
echo *** building HOMARD GUI without tool
echo.

cd %HOMARD_GUI_BUILD_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_EXECUTABLE=%SWIG_ROOT_DIR:\=/%/bin/swig.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_HOMARD_TOOL_STANDALONE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR:STRING="Visual Studio 15 2017 Win64"

set MSBUILDDISABLENODEREUSE=1

echo.
echo *** cmake %CMAKE_OPTIONS%
%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj"
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation of HOMARD...
echo *********************************************************************
echo

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)


SET OLD_PATH=%PATH%
SET GFORTRAN_EXE=%MINGW_ROOT_DIR%\bin\gfortran.exe
SET PATH=%MINGW_ROOT_DIR%\bin;%PATH%

echo.
echo *********************************************************************
echo *** building MEDFILE
echo *********************************************************************
echo.

cd %MEDFILE_BUILD_DIR%
SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%MEDFILE_INSTALL_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_STATIC_LIBS:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ROOT_DIR:STRING=%HDF5_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_MEDINT_TYPE:STRING="long long"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/gfortran.exe
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SH="CMAKE_SH-NOTFOUND"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_FLAGS="-g -O2 -ffixed-line-length-none"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_USE_MPI:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="MinGW Makefiles"

echo.
echo *********************************************************************
echo *** cmake %CMAKE_OPTIONS% %MEDFILE_SOURCE_DIR%
echo *********************************************************************
echo.
%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %MEDFILE_SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake: failed to run cmake for product MEDFILE..."
    exit 4
)

REM
echo.
echo *********************************************************************
echo *** Compilation of MEDFILE with mingw32-make
echo *********************************************************************
echo.
mingw32-make
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make: failed to compile MEDFILE Tool...
    exit 8
)

echo.
echo *********************************************************************
echo *** Installation of MEDFILE Tool with mingw32-make install...
echo *********************************************************************
echo.
mingw32-make install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make install: failed to install MEDFILE...
    exit 9
)

set MED3HOME=%MEDFILE_INSTALL_DIR%
set MED2HOME=%MEDFILE_INSTALL_DIR%
set MEDFILE_ROOT_DIR=%MEDFILE_INSTALL_DIR%
set PATH=%MEDFILE_INSTALL_DIR%\bin;%PATH%
set PATH=%MEDFILE_INSTALL_DIR%\lib;%PATH%


echo.
echo *** building HOMARD tool
echo.

cd %HOMARD_TOOL_BUILD_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%\bin\salome\tool
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_HOMARD_TOOL_STANDALONE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_EXECUTABLE=%SWIG_ROOT_DIR:\=/%/bin/swig.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/gfortran.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/g++.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_COMPILER=%MINGW_ROOT_DIR:\=/%/bin/gcc.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_EXE_LINKER_FLAGS="-Wl,--allow-multiple-definition"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SH="CMAKE_SH-NOTFOUND"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="MinGW Makefiles"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSALOME_INSTALL_LIBS=%PRODUCT_INSTALL:\=/%/lib/salome/tool
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSALOME_INSTALL_BINS=%PRODUCT_INSTALL:\=/%/bin/salome/tool

echo.
echo *********************************************************************
echo *** cmake %CMAKE_OPTIONS% %HOMARD_TOOL_SOURCE_DIR%
echo *********************************************************************

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %HOMARD_TOOL_SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake: failed to run cmake for product HOMARD Tool..."
    exit 7
)

echo.
echo *********************************************************************
echo *** Compilation of HDF5 with mingw32-make
echo *********************************************************************
echo.
mingw32-make
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make: failed to compile HOMARD Tool...
    exit 8
)

echo.
echo *********************************************************************
echo *** Installation of HOMARD TOOL with mingw32-make install...
echo *********************************************************************
echo.
mingw32-make install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on mingw32-make install: failed to install HOMARD...
    exit 9
)

REM finally embed required libraries
cp %MEDFILE_INSTALL_DIR%\lib\libmedC.dll %PRODUCT_INSTALL%\bin\salome\tool\libmedC.dll
cp %MEDFILE_INSTALL_DIR%\lib\libmedfwrap.dll %PRODUCT_INSTALL%\bin\salome\tool\libmedfwrap.dll
cp %MINGW_ROOT_DIR%\bin\libgcc_s_seh-1.dll %PRODUCT_INSTALL%\bin\salome\tool\libgcc_s_seh-1.dll
cp %MINGW_ROOT_DIR%\bin\libwinpthread-1.dll %PRODUCT_INSTALL%\bin\salome\tool\libwinpthread-1.dll
cp %MINGW_ROOT_DIR%\bin\libstdc++-6.dll %PRODUCT_INSTALL%\bin\salome\tool\libstdc++-6.dll
cp %MINGW_ROOT_DIR%\bin\libquadmath-0.dll %PRODUCT_INSTALL%\bin\salome\tool\libquadmath-0.dll


echo.
echo ########## END
