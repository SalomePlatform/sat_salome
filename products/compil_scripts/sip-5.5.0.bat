@echo off

echo ##########################################################################
echo  SIP %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%\sip-5.5.0
mkdir %PRODUCT_INSTALL%\Lib\site-packages
set PATH=%CWD%\bin;%PATH%
set PYTHONPATH=%PYTHONPATH%;%PRODUCT_INSTALL%\Lib\site-packages

echo.
echo *** 
%PYTHONBIN% setup.py build install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on SIP running  %PYTHONBIN% setup.py  build install   --prefix=%PRODUCT_INSTALL%
  exit 1
)
cd %BUILD_DIR%\PyQt5_sip-12.8.1
%PYTHONBIN% setup.py build install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on PYQT_SIP running  %PYTHONBIN% setup.py  build install  --prefix=%PRODUCT_INSTALL%
  exit 2
)

echo
echo ########## END
