@echo off

echo ##########################################################################
echo gmsh %VERSION%
echo ##########################################################################


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET BLAS_LAPACK_LIBRARIES="%LAPACK_ROOT_DIR%\lib\libblas.dll.a;%LAPACK_ROOT_DIR%\lib\libcblas.dll.a;%LAPACK_ROOT_DIR%\lib\liblapack.dll.a;%LAPACK_ROOT_DIR%\lib\liblapacke.dll.a"
cd %BUILD_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=Release
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_LIB=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_ACIS=OFF 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_FLTK=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_ONELAB_METAMODEL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PARSER=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PETSC=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PRIVATE_API=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_CGNS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_HXT=OFF 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR:STRING="Visual Studio 15 2017 Win64"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBLAS_LAPACK_LIBRARIES:STRING=%BLAS_LAPACK_LIBRARIES%

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x64 ALL_BUILD.vcxproj"
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild gmsh.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x64 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo.
echo *********************************************************************
echo *** installation Headers...
echo *********************************************************************
echo.
msbuild  /p:Configuration=Release /p:Platform=x64  /p:BuildProjectReferences=false get_headers.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild get_headers.vcxproj
    exit 4
)

copy /Y /B %BUILD_DIR%\Release\gmsh.lib %PRODUCT_INSTALL%\bin\gmsh.lib
copy /Y /B %BUILD_DIR%\Release\gmsh.exp %PRODUCT_INSTALL%\bin\gmsh.exp

SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (gmsh.h gmsh.h_cwrap gmshc.h) do (
   set X=%%f
   copy /Y %SOURCE_DIR%\api\%%f %PRODUCT_INSTALL%\include\%X%
)
ENDLOCAL

cd %BUILD_DIR%\Headers\gmsh
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (*.h) do (
   set X=%%f
   copy /Y %SOURCE_DIR%\api\%%f %PRODUCT_INSTALL%\include\%X%
)
ENDLOCAL

echo.
echo ########## END