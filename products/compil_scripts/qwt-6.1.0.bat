@echo off

echo ##########################################################################
echo qwt %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)
cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** prepare qmake
echo --------------------------------------------------------------------------
echo.

rem # Remplacement des antislashs par des slashs
set str=%PRODUCT_INSTALL%
set str=%str:\=/%

call :GETTEMPNAME
attrib -R qwtconfig.pri 
sed "s|\(QWT_INSTALL_PREFIX[[:space:]]*\)=\([[:space:]]*\)\(.*\)|\1=\2%str%|g" < qwtconfig.pri > %tmpfile%
move /y %tmpfile% qwtconfig.pri

cd designer
call :GETTEMPNAME
attrib -R designer.pro 
sed "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/plugins/designer|g" < designer.pro > %tmpfile%
move /y %tmpfile% designer.pro
cd ..

rem # Desactivation du mode Debug
call :GETTEMPNAME
attrib -R qwtbuild.pri
sed "s|\(CONFIG[[:space:]]*+=[[:space:]]*debug_and_release\)|#\1|g" < qwtbuild.pri > %tmpfile%
move /y %tmpfile% qwtbuild.pri
sed "s|\(CONFIG[[:space:]]*+=[[:space:]]*build_all\)|#\1|g" < qwtbuild.pri > %tmpfile%
move /y %tmpfile% qwtbuild.pri

echo.
echo --------------------------------------------------------------------------
echo *** qmake
echo --------------------------------------------------------------------------
echo.

qmake
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on qmake : %ERRORLEVEL%
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake
echo --------------------------------------------------------------------------
echo.

nmake 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake install
echo --------------------------------------------------------------------------
echo.

nmake install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake install
    exit 3
)

echo.
echo ########## END

:: ========== FUNCTIONS ==========
exit /B

:GETTEMPNAME
  set tmpfile=%TMP%\mytempfile-%RANDOM%.tmp
  if exist "%tmpfile%" GOTO :GETTEMPNAME 
  exit /B
