@echo off

echo ##########################################################################
echo FreeType %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
REM if %SAT_DEBUG% == 1 (
REM   set PRODUCT_BUILD_TYPE=Debug
REM )

if NOT exist "%PRODUCT_INSTALL%" mkdir  %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=TRUE
if defined CMAKE_GENERATOR (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)
set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% ALL_BUILD.vcxproj"
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation... msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% INSTALL.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

echo.
echo *********************************************************************
echo *** COPY Freetype DLL file from %BUILD_DIR% to %PRODUCT_INSTALL%
echo *********************************************************************
echo.
if NOT exist "%PRODUCT_INSTALL%\bin"     mkdir  %PRODUCT_INSTALL%\bin
copy /Y  %BUILD_DIR%\%PRODUCT_BUILD_TYPE%\Freetype.dll %PRODUCT_INSTALL%\bin\Freetype.dll 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying Freetype DLL
    exit 2
)


REM needed by ParaView
copy /Y %PRODUCT_INSTALL%\include\freetype2\ft2build.h %PRODUCT_INSTALL%\include\freetype2\freetype\ft2build.h
copy /Y %SOURCE_DIR%\include\freetype\config\ftconfig.h %PRODUCT_INSTALL%\include\freetype2\freetype\config\ftconfig.h

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
