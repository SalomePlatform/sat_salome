@echo off

echo ##########################################################################
echo openSSL %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

mkdir %PRODUCT_INSTALL%

cd %SOURCE_DIR%
xcopy amd64\include\* %PRODUCT_INSTALL%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)
xcopy amd64\*.lib %PRODUCT_INSTALL%\lib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy of openssl static libraries
    exit 1
)
xcopy amd64\*.dll %PRODUCT_INSTALL%\lib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy of openssl dll files
    exit 1
)

xcopy amd64\*.pdb %PRODUCT_INSTALL%\lib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy of openssl pdb fils
    exit 1
)

cd %PRODUCT_INSTALL%\lib
copy /Y /B libcrypto-1.1.dll libcrypto.dll 
copy /Y /B libssl-1.1.dll libssl.dll 
copy /Y /B libcrypto-1.1.lib libcrypto.lib
copy /Y /B libssl-1.1.lib libssl.lib

echo.
echo ########## END
