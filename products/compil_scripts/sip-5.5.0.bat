@echo off

echo ##########################################################################
echo  SIP + PyQt5_sip %VERSION%
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


set python_name=python%PYTHON_VERSION%

rem mkdir %PRODUCT_INSTALL%\lib\%python_name%\site-packages
set PATH=%CWD%\bin;%PATH%
REM set PYTHONPATH=%PRODUCT_INSTALL%\lib\%python_name%\site-packages;%PYTHONPATH%

echo.
echo *** build with %PYTHONBIN%
%PYTHONBIN% setup.py build
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on SIP running  %PYTHONBIN% setup.py build...
  exit 1
)

echo.
echo *** install with %PYTHONBIN%
%PYTHONBIN% setup.py install --prefix=%PRODUCT_INSTALL%\lib\%python_name%\site-packages
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on SIP running  %PYTHONBIN% setup.py install --prefix=%PRODUCT_INSTALL:\=/%
  exit 2
)

cd %BUILD_DIR%\PyQt5_sip-12.8.1

echo.
echo *** build with %PYTHONBIN%
%PYTHONBIN% setup.py build
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on PyQt5_sip running  %PYTHONBIN% setup.py build...
  exit 3
)

echo.
echo *** install with %PYTHONBIN%
%PYTHONBIN% setup.py install --prefix=%PRODUCT_INSTALL:\=/%
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on PyQt5_sip running  %PYTHONBIN% setup.py install --prefix=%PRODUCT_INSTALL:\=/%
  exit 4
)

mkdir %PRODUCT_INSTALL%\include
xcopy /q /r /Y *.h %PRODUCT_INSTALL%\include


echo
echo ########## END
