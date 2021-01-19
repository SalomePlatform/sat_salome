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
set QT_OPTIONS=%QT_OPTIONS%  -skip qtwebengine  -skip wayland -skip qtgamepad -no-openssl
set QT_OPTIONS=%QT_OPTIONS% -prefix %PRODUCT_INSTALL%
echo **** call configure  %QT_OPTIONS%
call configure  %QT_OPTIONS%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on configure"
    exit 1
)

REM Compilation with nmake as said in qt documentation
REM nmake can crash because of multi-threading problems
REM Thus, we will try to run it 42 times until it works
set /a remaining_tries = 42
:nmake
echo *** Trying to run nmake %remaining_tries% more time.
set /a remaining_tries = remaining_tries - 1
nmake
if NOT %ERRORLEVEL% == 0 if %remaining_tries% gtr 0 (
    goto nmake
)
if %remaining_tries% == 0 (
    echo "ERROR on nmake"
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

echo.
echo ########## END

