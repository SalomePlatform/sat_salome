@echo off

echo ##########################################################################
echo libpng %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

REM current built by Opencascade. move to the commented section below once agreed.
SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
REM if %SAT_DEBUG% == 1 (
REM   set PRODUCT_BUILD_TYPE=Debug
REM )
if NOT exist "%PRODUCT_INSTALL%" mkdir "%PRODUCT_INSTALL%"
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

cd "%SOURCE_DIR%"

xcopy include %PRODUCT_INSTALL%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 1
)

xcopy bin %PRODUCT_INSTALL%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy bin
    exit 1
)

echo.
echo ########## END
