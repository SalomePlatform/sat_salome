@echo off

echo ##########################################################################
echo Qt %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=-release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=-debug-and-release
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

REM Configure
echo.
echo --------------------------------------------------------------------------
echo *** configure  
echo --------------------------------------------------------------------------
set QT_OPTIONS=-platform win32-msvc2017
set QT_OPTIONS=%QT_OPTIONS% -opensource -confirm-license %PRODUCT_BUILD_TYPE%
set QT_OPTIONS=%QT_OPTIONS% -no-angle -opengl desktop -nomake examples -nomake tests 
set QT_OPTIONS=%QT_OPTIONS% -skip qtwebengine  -skip wayland -skip qtgamepad

IF DEFINED OPENSSL_ROOT_DIR (
  set QT_OPTIONS=%QT_OPTIONS% -ssl  -openssl -openssl-linked OPENSSL_PREFIX=%OPENSSL_ROOT_DIR%
) else (
  set QT_OPTIONS=%QT_OPTIONS% -no-openssl
)

set QT_OPTIONS=%QT_OPTIONS% -mp
set QT_OPTIONS=%QT_OPTIONS% -prefix %PRODUCT_INSTALL%

echo **** call %SOURCE_DIR%\configure  %QT_OPTIONS%
call %SOURCE_DIR%\configure.bat  %QT_OPTIONS%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on configure"
    exit 1
)

nmake
if NOT %ERRORLEVEL% == 0 (
  exit 2
)

REM Installation
echo.
echo --------------------------------------------------------------------------
echo *** nmake install
echo --------------------------------------------------------------------------

nmake install
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 3
)

echo "*** Adding qt.conf file in order to be able to compile using the moved Qt installation"
echo [Paths] >  %PRODUCT_INSTALL%\bin\qt.conf
echo Prefix=../ >> %PRODUCT_INSTALL%\bin\qt.conf

IF DEFINED OPENSSL_ROOT_DIR (
  copy /Y /B %OPENSSL_ROOT_DIR%\lib\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y /B %OPENSSL_ROOT_DIR%\lib\*.lib %PRODUCT_INSTALL%\lib\
)

echo.
echo ########## END

