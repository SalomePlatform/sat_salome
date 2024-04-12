@echo off

echo ##########################################################################
echo Python %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

set PLATFORM_TARGET=x64
if "%SALOME_APPLICATION_NAME%" == "URANIE" (
  set PLATFORM_TARGET=Win32
)

SET LIB_TAG=
if %SAT_DEBUG% == 1 (
  set LIB_TAG=_d
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\libs" mkdir %PRODUCT_INSTALL%\libs
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

SET MSBUILDDISABLENODEREUSE=1

cd %BUILD_DIR%\PCbuild

REM Upgrade to current version of MSVC
echo.
echo *** devenv pcbuild.sln /upgrade
devenv pcbuild.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

echo.

cd PCBuild

echo.
echo Extracting bzip2...
if exist "%BUILD_DIR%\externals\cpython-source-deps-bzip2-1.0.8" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-bzip2-1.0.8"
if exist "%BUILD_DIR%\externals\bzip2-1.0.8" rmdir /Q /S "%BUILD_DIR%\externals\bzip2-1.0.8"
7z x -y %BUILD_DIR%\externals\zips\bzip2-1.0.8.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-bzip2-1.0.8 %BUILD_DIR%\externals\bzip2-1.0.8

echo.
echo Extracting ffi...
if exist "%BUILD_DIR%\externals\cpython-bin-deps-libffi-3.3.0" rmdir /Q /S "%BUILD_DIR%\externals\cpython-bin-deps-libffi-3.3.0"
7z x -y %BUILD_DIR%\externals\zips\libffi-3.3.0.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-bin-deps-libffi-3.3.0 %BUILD_DIR%\externals\libffi-3.3.0

echo.
echo Extracting nasm...
if exist "%BUILD_DIR%\externals\cpython-bin-deps-nasm-2.11.06" rmdir /Q /S "%BUILD_DIR%\externals\cpython-bin-deps-nasm-2.11.06"
if exist "%BUILD_DIR%\externals\nasm-2.11.06" rmdir /Q /S "%BUILD_DIR%\externals\nasm-2.11.06"
7z x -y %BUILD_DIR%\externals\zips\nasm-2.11.06.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-bin-deps-nasm-2.11.06 %BUILD_DIR%\externals\nasm-2.11.06

echo.
echo Extracting openssl...
if exist "%BUILD_DIR%\externals\cpython-source-deps-openssl-1.1.1n" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-openssl-1.1.1n"
if exist "%BUILD_DIR%\externals\openssl-1.1.1n" rmdir /Q /S "%BUILD_DIR%\externals\openssl-1.1.1n"
7z x -y %BUILD_DIR%\externals\zips\openssl-1.1.1n.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-openssl-1.1.1n %BUILD_DIR%\externals\openssl-1.1.1n

if exist "%BUILD_DIR%\externals\cpython-bin-deps-openssl-bin-1.1.1n" rmdir /Q /S "%BUILD_DIR%\externals\cpython-bin-deps-openssl-bin-1.1.1n"
if exist "%BUILD_DIR%\externals\openssl-bin-1.1.1n" rmdir /Q /S "%BUILD_DIR%\externals\openssl-bin-1.1.1n"
7z x -y %BUILD_DIR%\externals\zips\openssl-bin-1.1.1n.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-bin-deps-openssl-bin-1.1.1n %BUILD_DIR%\externals\openssl-bin-1.1.1n

echo.
echo Extracting sqlite...
if exist "%BUILD_DIR%\externals\cpython-source-deps-sqlite-3.37.2.0" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-sqlite-3.37.2.0"
if exist "%BUILD_DIR%\externals\sqlite-3.37.2.0" rmdir /Q /S "%BUILD_DIR%\externals\sqlite-3.37.2.0"
7z x -y %BUILD_DIR%\externals\zips\sqlite-3.37.2.0.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-sqlite-3.37.2.0 %BUILD_DIR%\externals\sqlite-3.37.2.0

echo.
echo Extracting tkinter/tcl
if exist "%BUILD_DIR%\externals\cpython-source-deps-tcl-core-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-tcl-core-8.6.12.0"
if exist "%BUILD_DIR%\externals\tcl-core-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\tcl-core-8.6.12.0"
7z x -y %BUILD_DIR%\externals\zips\tcl-core-8.6.12.0.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-tcl-core-8.6.12.0 %BUILD_DIR%\externals\tcl-core-8.6.12.0

echo.
echo Extracting tkinter/tcltk
if exist "%BUILD_DIR%\externals\cpython-bin-deps-tcltk-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\cpython-bin-deps-tcltk-8.6.12.0"
if exist "%BUILD_DIR%\externals\tcltk-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\tcltk-8.6.12.0"
7z x -y %BUILD_DIR%\externals\zips\tcltk-8.6.12.0.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-bin-deps-tcltk-8.6.12.0 %BUILD_DIR%\externals\tcltk-8.6.12.0

echo.
echo Extracting tix
if exist "%BUILD_DIR%\externals\cpython-source-deps-tix-8.4.3.6" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-tix-8.4.3.6"
if exist "%BUILD_DIR%\externals\tix-8.4.3.6" rmdir /Q /S "%BUILD_DIR%\externals\tix-8.4.3.6"
7z x -y %BUILD_DIR%\externals\zips\tix-8.4.3.6.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-tix-8.4.3.6 %BUILD_DIR%\externals\tix-8.4.3.6

echo.
echo Extracting tkinter/tk
if exist "%BUILD_DIR%\externals\cpython-source-deps-tk-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-tk-8.6.12.0"
if exist "%BUILD_DIR%\externals\tk-8.6.12.0" rmdir /Q /S "%BUILD_DIR%\externals\tk-8.6.12.0"
7z x -y %BUILD_DIR%\externals\zips\tk-8.6.12.0.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-bin-deps-tk-8.6.12.0 %BUILD_DIR%\externals\tk-8.6.12.0

echo.
echo Extracting xz...
if exist "%BUILD_DIR%\externals\cpython-source-deps-xz-5.2.5" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-xz-5.2.5"
if exist "%BUILD_DIR%\externals\xz-5.2.5" rmdir /Q /S "%BUILD_DIR%\externals\xz-5.2.5"
7z x -y %BUILD_DIR%\externals\zips\xz-5.2.5.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-xz-5.2.5 %BUILD_DIR%\externals\xz-5.2.5

echo.
echo Extracting zlib...
if exist "%BUILD_DIR%\externals\cpython-source-deps-zlib-1.2.12" rmdir /Q /S "%BUILD_DIR%\externals\cpython-source-deps-zlib-1.2.12"
if exist "%BUILD_DIR%\externals\zlib-1.2.12" rmdir /Q /S "%BUILD_DIR%\externals\zlib-1.2.12"
7z x -y %BUILD_DIR%\externals\zips\zlib-1.2.12.zip -o%BUILD_DIR%\externals
mv %BUILD_DIR%\externals\cpython-source-deps-zlib-1.2.12 %BUILD_DIR%\externals\zlib-1.2.12

echo Extracting pip...
if exist "%BUILD_DIR%\externals\pip-24.0" rmdir /Q /S "%BUILD_DIR%\externals\pip-24.0"
7z x -y %BUILD_DIR%\externals\zips\pip-24.0.zip -o%BUILD_DIR%\externals

REM Compilation

cd %BUILD_DIR%
echo.

REM Upgrade to current version of MSVC
echo.
echo *** devenv pcbuild.sln /upgrade
devenv pcbuild.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

echo *** msbuild %BUILD_DIR%\PCBuild\pcbuild.sln /t:Build /m /nologo /v:m /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET% /p:BuildProjectReferences=false /p:OutDir=%PRODUCT_INSTALL%\
msbuild %BUILD_DIR%\PCBuild\pcbuild.sln  /t:Build /m /nologo /v:m /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET% /p:OutDir=%PRODUCT_INSTALL%\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)

REM Installation of additional files
echo.
echo *** Installation of additional files
cd ..
xcopy /Y /I /E %BUILD_DIR%\include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 3
)

copy /Y %BUILD_DIR%\PC\pyconfig.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copy PC\pyconfig.h
    exit 4
)

xcopy /Y /I /E %BUILD_DIR%\lib %PRODUCT_INSTALL%\lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy lib
    exit 5
)

REM some prequistes if compiled in Debug mode require the lib to be in folder libs
REM other ones require these static lib to be in the root directory
REM on purpose we don't use mklink, since this requires the user to have his node set in developer mode.
xcopy  /Y %PRODUCT_INSTALL%\*.lib %PRODUCT_INSTALL%\libs\
if NOT %ERRORLEVEL% == 0 (
  echo ERROR could not copy static libraries
  exit 6
)

REM on purpose, we don't use mklink - requires admin rights...
copy /Y /B %PRODUCT_INSTALL%\python%LIB_TAG%.exe %PRODUCT_INSTALL%\python3.exe
if %SAT_DEBUG% == 1 (
  copy /Y /B %PRODUCT_INSTALL%\python_d.exe %PRODUCT_INSTALL%\python.exe
  REM otherwise OmniORB does not compile...
  copy /Y /B %PRODUCT_INSTALL%\libs\python39_d.lib %PRODUCT_INSTALL%\libs\python39.lib 
  copy /Y /B %PRODUCT_INSTALL%\libs\python_d.lib %PRODUCT_INSTALL%\libs\python.lib 
)

cd %PRODUCT_INSTALL%\

REM Add PIP support
set PYTHONHOME=%PRODUCT_INSTALL%
set PYTHON_ROOT_DIR=%PRODUCT_INSTALL%
set PYTHON_VERSION=3.9
set PATH=%PRODUCT_INSTALL%;%PATH%
set PATH=%PRODUCT_INSTALL%\lib;%PATH%
set PYTHON_INCLUDE=%PRODUCT_INSTALL%\include
set PYTHONPATH=%PRODUCT_INSTALL%\lib;%PYTHONPATH%
set PYTHONPATH=%PRODUCT_INSTALL%\lib\site-packages;%PYTHONPATH%
set PYTHONBIN=%PRODUCT_INSTALL%\python.exe
set PATH=%PRODUCT_INSTALL%\Scripts;%PATH%

%PRODUCT_INSTALL%\python.exe %BUILD_DIR%\externals\pip-24.0\get-pip.py --force-reinstall --no-setuptools --no-wheel  --no-index --find-links=%BUILD_DIR%\externals\pip-24.0

REM In debug mode, we need to rename all _d.pyd to .pyd... don't ask why. Seems like a known bug in OmniORB.
if %SAT_DEBUG% == 1 (
  cd %PRODUCT_INSTALL%
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
  cd %PRODUCT_INSTALL%\lib\site-packages
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
)


taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
