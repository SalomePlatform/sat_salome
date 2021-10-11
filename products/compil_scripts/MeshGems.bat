@echo off

echo ##########################################################################
echo MeshGems $VERSION
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

set SRC_FOLDER=Win7_64_VC14

cd DISTENE\MeshGems-*\Products

echo SRC_FOLDER = %SRC_FOLDER%
echo PRODUCT_INSTALL = %PRODUCT_INSTALL%

rem ## Includes
xcopy include\* %PRODUCT_INSTALL%\include /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copying include
    exit 1
)

rem ## Lib
echo. 
echo running command: xcopy lib\%SRC_FOLDER%\* %PRODUCT_INSTALL%\lib /E /I /Q /Y
xcopy lib\%SRC_FOLDER%\* %PRODUCT_INSTALL%\lib /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copying lib
    exit 2
)

rem ## Bin
echo. 
echo running command: bin\%SRC_FOLDER%\* %PRODUCT_INSTALL%\bin /E /I /Q /Y
xcopy bin\%SRC_FOLDER%\* %PRODUCT_INSTALL%\bin /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copying bin
    exit 3
)

echo.
echo ########## END
