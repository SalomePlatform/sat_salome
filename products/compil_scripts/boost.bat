@echo off

echo ##########################################################################
echo BOOST %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** Extracting distribution
echo --------------------------------------------------------------------------

call :NORMALIZEPATH "boost*exe"
set installer=%RETVAL%
if not exist "%installer%" (
    echo "ERROR no installer found."
    exit 1
)

echo Installer : %installer%

call %installer% /SILENT /SP- /NOICONS /NOCANCEL /NORESTART /DIR="%BUILD_DIR%" /LOG="%BUILD_DIR%\boost_install.log"
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on extraction."
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** Installation
echo --------------------------------------------------------------------------

cd "%BUILD_DIR%"

echo *** Includes...

set target_inc=%PRODUCT_INSTALL%\include\boost-1_58\boost
mkdir %target_inc%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when creating include directory : %target_inc%
    exit 30
)

robocopy %BUILD_DIR%\boost %target_inc% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying include
    exit 31
)

echo *** Libs...

set target_lib=%PRODUCT_INSTALL%\lib
mkdir %target_lib%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when creating lib directory : %target_lib%
    exit 32
)

rem Visual studio 2010 specific
robocopy %BUILD_DIR%\lib64-msvc-10.0  %target_lib% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying lib
    exit 33
)

echo.
echo ########## END

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B