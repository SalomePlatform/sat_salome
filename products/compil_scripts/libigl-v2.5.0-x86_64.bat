@echo off

echo ##########################################################################
echo libigl %VERSION%
echo ##########################################################################


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

REM Install the executable into the common directory
if NOT exist "%SINGLE_INSTALL_DIR%" mkdir %SINGLE_INSTALL_DIR%
if NOT exist "%SINGLE_INSTALL_DIR%\bin" mkdir %SINGLE_INSTALL_DIR%\bin
copy /B /Y %SOURCE_DIR%\bin\* %SINGLE_INSTALL_DIR%\bin\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy 609_Boolean.exe to %SINGLE_INSTALL_DIR%\bin
    exit 2
)

echo.
echo exec_libigl version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %SINGLE_INSTALL_DIR%\bin >> %PRODUCT_INSTALL%\README.txt

echo
echo ########## END
