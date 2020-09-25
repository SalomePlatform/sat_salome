@echo off

echo ##########################################################################
echo ADAO %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

echo ##########################################################################
echo Compile ADAO TOOL
echo ##########################################################################

set CURRENT_SOFTWARE_INSTALL_DIR=%PRODUCT_INSTALL:\=/%
set PYTHONPATH=%SOURCE_DIR%/bin;%PYTHONPATH%
set PYTHONPATH=%PRODUCT_INSTALL%/lib/python%PYTHON_VERSION%/site-packages;%PYTHONPATH%

cd %BUILD_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=Release
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR:STRING="Visual Studio 15 2017 Win64"

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
    echo ERROR on msbuild ALL_BUILD.vcxproj
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

echo ##########################################################################
echo Compile ADAO MODULE
echo ##########################################################################
set ADAO_PYTHON_ROOT_DIR=%CURRENT_SOFTWARE_INSTALL_DIR%
set ADAO_ENGINE_ROOT_DIR=%CURRENT_SOFTWARE_INSTALL_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=Release
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DADAO_PYTHON_MODULE:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DKERNEL_ROOT_DIR=%KERNEL_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DADAO_PYTHON_ROOT_DIR=%ADAO_PYTHON_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DEFICAS_ROOT_DIR=%EFICAS_TOOLS_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR:STRING="Visual Studio 15 2017 Win64"

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

REM set CL=/D__WIN32__ /DSIZEOF_INT=4 /DSIZEOF_LONG=4 %CL%

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x64 ALL_BUILD.vcxproj"
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:Platform=x64 ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
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

set MSBUILDDISABLENODEREUSE=1


