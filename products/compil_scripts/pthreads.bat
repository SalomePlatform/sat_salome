@echo off

echo ##########################################################################
echo PThreads %VERSION%
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
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

robocopy %SOURCE_DIR% %BUILD_DIR% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying archive %ERRORLEVEL%
    exit 1
)

cd %BUILD_DIR%

REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\pthread.sln /upgrade
devenv %BUILD_DIR%\pthread.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 2
)

REM Compilation
echo.
echo *** %BUILD_DIR%\pthread.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64

msbuild %BUILD_DIR%\pthread.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 3
)

echo.
echo --------------------------------------------------------------------------
echo *** Installing includes
echo --------------------------------------------------------------------------
echo.

xcopy %BUILD_DIR%\*.h %PRODUCT_INSTALL%\include\
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on copying includes"
    exit 4
)

echo.
echo --------------------------------------------------------------------------
echo *** Installing libs
echo --------------------------------------------------------------------------
echo.

xcopy %BUILD_DIR%\*.dll %PRODUCT_INSTALL%\lib\
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on copying dll files"
    exit 5
)

xcopy %BUILD_DIR%\*.lib %PRODUCT_INSTALL%\lib\
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on copying lib files"
    exit 6
)

copy %PRODUCT_INSTALL%\lib\pthreadVC2.lib %PRODUCT_INSTALL%\lib\pthreadVC2_64.lib
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on renaming lib\pthreadVC2.lib"
    exit 7
)

echo.
echo "########## END"
