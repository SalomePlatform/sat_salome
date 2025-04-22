@echo off

echo ##########################################################################
echo cgal %VERSION%
echo ##########################################################################


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.

cd %SOURCE_DIR%
xcopy * %PRODUCT_INSTALL% /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

REM Install the executable into the common directory
if NOT exist "%SINGLE_INSTALL_DIR%" mkdir %SINGLE_INSTALL_DIR%
if NOT exist "%SINGLE_INSTALL_DIR%\bin" mkdir %SINGLE_INSTALL_DIR%\bin
copy /B /Y %SOURCE_DIR%\bin\exec_cgal.exe %SINGLE_INSTALL_DIR%\bin\exec_cgal.exe
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not copy exec_cgal.exe to %SINGLE_INSTALL_DIR%\bin
    exit 2
)


echo.
echo exec_cgal version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %SINGLE_INSTALL_DIR%\bin >> %PRODUCT_INSTALL%\README.txt

echo
echo ########## END
