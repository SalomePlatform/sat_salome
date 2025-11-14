@echo off

echo ##########################################################################
echo ONNX %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM First copy license.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (LICENSE VERSION_NUMBER ThirdPartyNotices.txt README.md Privacy.md) do (
   set X=%%f
   copy /Y %SOURCE_DIR%\%X% %PRODUCT_INSTALL%\%X%
)
ENDLOCAL

REM DLL & static libraries
cd %SOURCE_DIR%\lib
xcopy * %PRODUCT_INSTALL%\lib /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy lib
    exit 1
)

REM Header files
cd %SOURCE_DIR%\include
xcopy * %PRODUCT_INSTALL%\include /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 1
)

REM Rearrange the include directory structure
cd %PRODUCT_INSTALL%\include
mkdir onnxruntime
MOVE /Y *.h onnxruntime
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not rearrange the include directory structure
    exit 1
)

echo.
echo ########## END
