@echo off

echo ##########################################################################
echo F2C %VERSION%
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

SET MSBUILDDISABLENODEREUSE=1
cd %BUILD_DIR%
robocopy %SOURCE_DIR% %BUILD_DIR% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying archive
    exit 1
)

REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\f2cAll.sln /upgrade
devenv %BUILD_DIR%\f2cAll.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

echo.
echo *** %BUILD_DIR%\LIBF77\Libf77.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64
msbuild %BUILD_DIR%\LIBF77\Libf77.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild. Cannot build Libf77
    exit 2
)

echo.
echo *** %BUILD_DIR%\LIBI77\Libi77.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64 
msbuild %BUILD_DIR%\LIBI77\Libi77.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild. Cannot build Libi77
    exit 2
)

REM the binary should be compiled in 32 bits mode, otherwise c generated files from fortran are empty...
REM see BOS #16524
echo.
echo *** %BUILD_DIR%\SRC\f2c.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x86 
msbuild %BUILD_DIR%\SRC\f2c.vcxproj /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x86
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild. Cannot build f2c.exe
    exit 2
)

echo.
echo *** COPY generated binary and libraries to %PRODUCT_INSTALL%
copy  %BUILD_DIR%\SRC\WinRel\f2c.exe %PRODUCT_INSTALL%\f2c.exe
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy %BUILD_DIR%\SRC\WinRel\f2c.exe
    exit 2
)

copy %BUILD_DIR%\LIBF77\WinRel\Libf77.lib %PRODUCT_INSTALL%\Libf77.lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying %BUILD_DIR%\LIBF77\WinRel\Libf77.lib
    exit 2
)

copy %BUILD_DIR%\LIBI77\WinRel\Libi77.lib %PRODUCT_INSTALL%\Libi77.lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying %BUILD_DIR%\LIBF77\WinRel\Libi77.lib
    exit 2
)

copy %BUILD_DIR%\F2C.H %PRODUCT_INSTALL%\F2C.H
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying %BUILD_DIR%\F2C.H
    exit 2
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
