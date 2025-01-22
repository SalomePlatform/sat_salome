@echo off

echo ##########################################################################
echo cork %VERSION%
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
copy /B /Y %SOURCE_DIR%\bin\wincork.pdb %SINGLE_INSTALL_DIR%\bin\wincork.pdb
copy /B /Y %SOURCE_DIR%\bin\wincork.exe %SINGLE_INSTALL_DIR%\bin\wincork.exe
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy exec_cork.exe to %SINGLE_INSTALL_DIR%\bin
    exit 2
)

echo.
echo wincork version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %SINGLE_INSTALL_DIR%\bin >> %PRODUCT_INSTALL%\README.txt

echo
echo ########## END
