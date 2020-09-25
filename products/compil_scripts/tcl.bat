@echo off

echo ##########################################################################
echo tcl %VERSION%
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

cd %BUILD_DIR%\win

echo.
echo --------------------------------------------------------------------------
echo *** prepare nmake
echo --------------------------------------------------------------------------

REM tcl/tk does not compile, this SDK tag is required
REM see https://wiki.tcl-lang.org/page/Building+with+Visual+Studio+2017
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64  10.0.15063.0 

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc
echo --------------------------------------------------------------------------
 
nmake -f makefile.vc
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake"
    exit 2
)

echo.
echo -------------------------------------------------------------------------- 
echo *** nmake -f makefile.vc install
echo -------------------------------------------------------------------------- 

nmake -f makefile.vc install INSTALLDIR=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 3
)

echo.
echo ########## END

