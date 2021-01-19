@echo off

echo ##########################################################################
echo FreeImage %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET MSBUILDDISABLENODEREUSE=1
cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd %BUILD_DIR%
REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\FreeImage.2017.sln /upgrade
devenv %BUILD_DIR%\FreeImage.2017.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

REM Compilation
echo.
echo *** %BUILD_DIR%\FreeImage.2017.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64 
msbuild %BUILD_DIR%\FreeImage.2017.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)


echo.
echo *** COPY FreeImage DLL to %PRODUCT_INSTALL%

if %SAT_DEBUG% == 1 (
  copy /Y %BUILD_DIR%\Dist\x64\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y %BUILD_DIR%\Dist\x64\*.lib %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Dist\x64\*.h %PRODUCT_INSTALL%\include\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\*.lib %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\*.h %PRODUCT_INSTALL%\include\
) else (
  copy /Y %BUILD_DIR%\Dist\x64\FreeImage.dll %PRODUCT_INSTALL%\bin\FreeImage.dll
  copy /Y %BUILD_DIR%\Dist\x64\FreeImage.lib %PRODUCT_INSTALL%\lib\FreeImage.lib
  copy /Y %BUILD_DIR%\Dist\x64\FreeImage.h %PRODUCT_INSTALL%\include\FreeImage.h
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\FreeImagePlus.dll %PRODUCT_INSTALL%\bin\FreeImagePlus.dll
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\FreeImagePlus.lib %PRODUCT_INSTALL%\lib\FreeImagePlus.lib
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\x64\FreeImagePlus.h %PRODUCT_INSTALL%\include\FreeImagePlus.h
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
