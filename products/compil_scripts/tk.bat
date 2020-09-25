@echo off

echo ##########################################################################
echo tk %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%\win

echo.
echo ****************************************************************
where.exe nmake

REM tcl/tk does not compile, this SDK tag is required
REM see https://wiki.tcl-lang.org/page/Building+with+Visual+Studio+2017
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64  10.0.15063.0 

echo.
echo ****************************************************************
where.exe nmake


call :NORMALIZEPATH "%BUILD_DIR%\..\tcl"
set TCLDIR=%RETVAL%

echo.
echo --------------------------------------------------------------------------
echo *** prepare nmake
echo --------------------------------------------------------------------------

dir rules.vc

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR%
echo --------------------------------------------------------------------------
 
nmake -f makefile.vc TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake"
    exit 1
)

echo.
echo -------------------------------------------------------------------------- 
echo *** nmake -f makefile.vc install TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR% INSTALLDIR=%TCLHOME%
echo -------------------------------------------------------------------------- 

nmake -f makefile.vc install TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR% INSTALLDIR=%TCLHOME%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 2
)

echo.
echo -------------------------------------------------------------------------- 
echo *** post-installation (%TCLHOME%)
echo -------------------------------------------------------------------------- 

echo "Tk is installed into tcl dir %TCLHOME%" > %PRODUCT_INSTALL%/README

rem tkConfig.sh n a pas ete 
rem cp tkConfig.sh %TCLHOME%/lib rem Needed fot netgen and Togl

echo.
echo ########## END

:: ========== FUNCTIONS ==========
exit /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
  
