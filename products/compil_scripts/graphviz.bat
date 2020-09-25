@echo off

echo ##########################################################################
echo Graphviz %VERSION%
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

cd %BUILD_DIR%
cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE% %SOURCE_DIR%
msbuild ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%
msbuild INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%
echo.
echo ########## END

