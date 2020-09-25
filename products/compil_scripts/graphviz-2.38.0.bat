@echo off

echo ##########################################################################
echo Graphviz %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

REM currently this external library is built by OpenCascade
REM As soon as we upgrade to 2.42, one needs to move to graphviz.bat
cd %SOURCE_DIR%

xcopy bin %PRODUCT_INSTALL%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy bin
    exit 1
)

xcopy include %PRODUCT_INSTALL%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 2
)

echo.
echo ########## END

