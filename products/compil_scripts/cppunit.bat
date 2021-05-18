@echo off

echo ##########################################################################
echo cppunit %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

set PLATFORM_TARGET=x64
if defined SALOME_APPLICATION_NAME if %SALOME_APPLICATION_NAME% == URANIE (
  set PLATFORM_TARGET=Win32
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo Sources copy into build directory... 
echo --------------------------------------------------------------------------

robocopy %SOURCE_DIR% %BUILD_DIR% /E /NP /NFL /NDL /NS /NC /NJH /NJS
if NOT %ERRORLEVEL% == 1 (
    echo ERROR %ERRORLEVEL% on robocopy
    exit 1
)

REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\src\cppunit\cppunit.vcxproj /upgrade
devenv %BUILD_DIR%\src\cppunit\cppunit.vcxproj /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

echo.
echo -------------------------------------------------------------------------------
echo msbuild cppunit.vcxproj %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET%
echo -------------------------------------------------------------------------------

cd %BUILD_DIR%\src\cppunit

msbuild cppunit.vcxproj %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 21
)

msbuild cppunit.vcxproj %MAKE_OPTIONS% /p:Configuration=Debug /p:TargetName=cppunitd /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 22
)

msbuild cppunit_dll.vcxproj %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 23
)

msbuild cppunit_dll.vcxproj %MAKE_OPTIONS% /p:Configuration=Debug /p:TargetName=cppunitd_dll /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 24
)

echo.
echo --------------------------------------------------------------------------
echo Installation
echo --------------------------------------------------------------------------

xcopy /i /e %BUILD_DIR%\include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on 'include' copy
    exit 31
)

xcopy /i /e %BUILD_DIR%\lib %PRODUCT_INSTALL%\lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on 'lib' copy
    exit 32
) 

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
