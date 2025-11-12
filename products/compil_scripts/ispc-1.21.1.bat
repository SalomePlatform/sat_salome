@echo off

echo ##########################################################################
echo ispc %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
SET MSBUILDDISABLENODEREUSE=1
cd %SOURCE_DIR%\bin
xcopy * %PRODUCT_INSTALL%\bin /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy bin
    exit 1
)

cd %SOURCE_DIR%\lib
xcopy * %PRODUCT_INSTALL%\lib /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy lib
    exit 1
)

cd %SOURCE_DIR%\include
xcopy * %PRODUCT_INSTALL%\include /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 1
)

echo.
echo ########## END
