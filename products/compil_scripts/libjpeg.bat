@echo off

echo ##########################################################################
echo libjpeg %VERSION%
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
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET MSBUILDDISABLENODEREUSE=1
cd %BUILD_DIR%
robocopy %SOURCE_DIR% %BUILD_DIR% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying source files
    exit 1
)

REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\jpeg.sln /upgrade
devenv %BUILD_DIR%\jpeg.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

REM Build LIB
echo.
echo *** msbuild %BUILD_DIR%\jpeg.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64 
msbuild %BUILD_DIR%\jpeg.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)

REM Build DLL
echo.
echo *** msbuild %BUILD_DIR%\jpeg.sln /t:build /p:Configuration=DLL;Platform=x64 
msbuild %BUILD_DIR%\jpeg.sln /t:build /p:Configuration=DLL;Platform=x64 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)

echo.
echo *** COPY jpeg LIB to %PRODUCT_INSTALL%
cp %BUILD_DIR%\x64\%PRODUCT_BUILD_TYPE%\jpeg.lib %PRODUCT_INSTALL%\bin\jpeg.lib 
cp %BUILD_DIR%\x64\DLL\jpeg.dll %PRODUCT_INSTALL%\bin\jpeg.dll 

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
