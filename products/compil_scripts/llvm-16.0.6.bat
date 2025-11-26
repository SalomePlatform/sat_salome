@echo off

echo ##########################################################################
echo llvm %VERSION%
echo ##########################################################################

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

REM NGH: no need to build this in debug mode
SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if NOT exist "%PRODUCT_INSTALL%" mkdir "%PRODUCT_INSTALL%"

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

cd "%BUILD_DIR%"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:PATH=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON  
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_DUMP:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INCLUDE_TESTS:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INCLUDE_UTILS:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_PROJECTS="clang;flang"
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING=MultiThreadedDLL
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_POLICY_DEFAULT_CMP0091:STRING=NEW
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_NAME_DIR:STRING=%PRODUCT_INSTALL:\=/%/lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_RTTI:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INSTALL_UTILS:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_LIBXML2:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_BINDINGS:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_ENABLE_ZSTD:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_INCLUDE_RUNTIMES:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLLVM_TARGETS_TO_BUILD:STRING=X86
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_EXECUTABLE:FILEPATH=%PYTHON_ROOT_DIR:\=/%/python.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Thost=x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR% -A x64

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%\llvm
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
echo ########## END
