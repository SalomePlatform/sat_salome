@echo off

echo ##########################################################################
echo zlib %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

xcopy include %PRODUCT_INSTALL%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 1
)

xcopy bin %PRODUCT_INSTALL%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy bin
    exit 2
)

echo.
echo ########## END

REM if exist "%PRODUCT_INSTALL%" rmdir /Q /S "%PRODUCT_INSTALL%"
REM mkdir %PRODUCT_INSTALL%

REM set CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
REM if defined CMAKE_GENERATOR (
    REM set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
REM ) else (
    REM set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
REM )
REM set MSBUILDDISABLENODEREUSE=1

REM cd %BUILD_DIR%

REM echo.
REM echo --------------------------------------------------------------------------
REM echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
REM echo --------------------------------------------------------------------------

REM %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
REM if NOT %ERRORLEVEL% == 0 (
    REM echo ERROR on cmake
    REM exit 1
REM )

REM echo.
REM echo --------------------------------------------------------------------------
REM echo *** %CMAKE_ROOT%\bin\cmake --build . --config Release --target INSTALL
REM echo --------------------------------------------------------------------------

REM %CMAKE_ROOT%\bin\cmake --build . --config Release --target INSTALL
REM if NOT %ERRORLEVEL% == 0 (
    REM echo ERROR on cmake build
    REM exit 2
REM )

REM cp %PRODUCT_INSTALL%\lib\zlib.lib %PRODUCT_INSTALL%\lib\zlib1.lib
REM cp %PRODUCT_INSTALL%\lib\zlib.lib %PRODUCT_INSTALL%\lib\z.lib
REM cp %PRODUCT_INSTALL%\bin\zlib.dll %PRODUCT_INSTALL%\bin\zlib1.dll

REM taskkill /F /IM "mspdbsrv.exe"

REM echo.
REM echo ########## END