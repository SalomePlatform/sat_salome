@echo off

echo ##########################################################################
echo gmsh %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET BUILD_SHARED=ON
SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
  set BUILD_SHARED=OFF
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_BUILD_LIB=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_BUILD_SHARED=%BUILD_SHARED%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_BUILD_DYNAMIC=%BUILD_SHARED%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_ACIS=OFF 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_FLTK=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_ONELAB_METAMODEL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PARSER=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PETSC=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PRIVATE_API=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_CGNS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_TESTS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_PLUGINS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -A x64
  
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
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild gmsh.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo.
echo *********************************************************************
echo *** installation Headers...
echo *********************************************************************
echo.
msbuild  /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64  /p:BuildProjectReferences=false get_headers.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild get_headers.vcxproj
    exit 4
)

copy /Y /B %BUILD_DIR%\%PRODUCT_BUILD_TYPE%\*.lib %PRODUCT_INSTALL%\bin
copy /Y /B %BUILD_DIR%\%PRODUCT_BUILD_TYPE%\*.exp %PRODUCT_INSTALL%\bin

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

cd %PRODUCT_INSTALL%\include\gmsh
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (*.h) do (
   set X=%%f
   copy /Y %PRODUCT_INSTALL%\include\gmsh\%%f %PRODUCT_INSTALL%\include\%X%
)
ENDLOCAL

REM these two files need to be moved to bin, adding bin directory to PATH does not help.
cp %PRODUCT_INSTALL%\lib\gmsh.py %PRODUCT_INSTALL%\bin\gmsh.py
if %SAT_DEBUG% == 0 (
  cp %PRODUCT_INSTALL%\lib\gmsh.dll %PRODUCT_INSTALL%\bin\gmsh.dll
)

echo.
echo ########## END
