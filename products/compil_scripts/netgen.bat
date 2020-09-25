@echo off

echo ##########################################################################
echo NETGEN %VERSION%
echo ##########################################################################

dos2unix -q %SOURCE_DIR%/libsrc/occ/*
dos2unix -q %SOURCE_DIR%/libsrc/nglib/*

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
if defined CMAKE_GENERATOR (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)
set MSBUILDDISABLENODEREUSE=1

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_ROOT_DIR=%ZLIB_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCASROOT=%CASROOT%

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=Release ALL_BUILD.vcxproj"
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=Release ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation... msbuild %MAKE_OPTIONS% /p:Configuration=Release INSTALL.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=Release INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

REM move DLL to bin, in order to reduce the PATH length..
MOVE /Y %PRODUCT_INSTALL%\lib\nglib.dll  %PRODUCT_INSTALL%\bin\nglib.dll
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not move DLL to BIN directory...
    exit 4
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
