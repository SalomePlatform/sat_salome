@echo off

echo ##########################################################################
echo pip %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%


cd %SOURCE_DIR%

REM 
python --version
echo python get-pip.py --force-reinstall --no-setuptools --no-wheel  --no-index --find-links=%SOURCE_DIR%
python get-pip.py --force-reinstall --no-setuptools --no-wheel  --no-index --find-links=%SOURCE_DIR%
echo.
echo ########## END
