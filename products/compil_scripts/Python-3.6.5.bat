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

SET MSBUILDDISABLENODEREUSE=1

cd %SOURCE_DIR%\PCbuild

REM Upgrade to current version of MSVC
echo.
echo *** devenv pcbuild.sln /upgrade
devenv pcbuild.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)


echo.
REM echo Extracting nasm...
if exist "%SOURCE_DIR%\externals\cpython-bin-deps-nasm-2.11.06" rmdir /Q /S "%SOURCE_DIR%\externals\cpython-bin-deps-nasm-2.11.06"
if exist "%SOURCE_DIR%\externals\nasm-2.11.06" rmdir /Q /S "%SOURCE_DIR%\externals\nasm-2.11.06"
7z x -y %SOURCE_DIR%\externals\zips\nasm-2.11.06.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-bin-deps-nasm-2.11.06 %SOURCE_DIR%\externals\nasm-2.11.06

REM echo Extracting openssl...
if exist "%SOURCE_DIR%\externals\cpython-source-deps-openssl-1.0.2k" rmdir /Q /S "%SOURCE_DIR%\externals\cpython-source-deps-openssl-1.0.2k"
if exist "%SOURCE_DIR%\externals\openssl-1.0.2k" rmdir /Q /S "%SOURCE_DIR%\externals\openssl-1.0.2k"
7z x -y %SOURCE_DIR%\externals\zips\openssl-1.0.2k.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-openssl-1.0.2k %SOURCE_DIR%\externals\openssl-1.0.2k

REM echo Extracting sqlite...
if exist "%SOURCE_DIR%\externals\cpython-source-deps-sqlite-3.21.0.0" rmdir /Q /S "%SOURCE_DIR%\externals\cpython-source-deps-sqlite-3.21.0.0"
if exist "%SOURCE_DIR%\externals\sqlite-3.21.0.0" rmdir /Q /S "%SOURCE_DIR%\externals\sqlite-3.21.0.0"
7z x -y %SOURCE_DIR%\externals\zips\sqlite-3.21.0.0.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-sqlite-3.21.0.0 %SOURCE_DIR%\externals\sqlite-3.21.0.0

REM echo Extracting xz...
if exist "%SOURCE_DIR%\externals\cpython-source-deps-xz-5.2.2" rmdir /Q /S "%SOURCE_DIR%\externals\cpython-source-deps-xz-5.2.2"
if exist "%SOURCE_DIR%\externals\xz-5.2.2" rmdir /Q /S "%SOURCE_DIR%\externals\xz-5.2.2"
7z x -y %SOURCE_DIR%\externals\zips\xz-5.2.2.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-xz-5.2.2 %SOURCE_DIR%\externals\xz-5.2.2

REM echo Extracting xz...
if exist "%SOURCE_DIR%\externals\cpython-source-deps-bzip2-1.0.6" rmdir /Q /S "%SOURCE_DIR%\externals\cpython-source-deps-bzip2-1.0.6"
if exist "%SOURCE_DIR%\externals\bzip2-1.0.6" rmdir /Q /S "%SOURCE_DIR%\externals\bzip2-1.0.6"
7z x -y %SOURCE_DIR%\externals\zips\bzip2-1.0.6.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-bzip2-1.0.6 %SOURCE_DIR%\externals\bzip2-1.0.6

REM echo Extracting pip...
if exist "%SOURCE_DIR%\externals\pip-19.1.1" rmdir /Q /S "%SOURCE_DIR%\externals\pip-19.1.1"
7z x -y %SOURCE_DIR%\externals\zips\pip-19.1.1.zip -o%SOURCE_DIR%\externals

REM Compilation

cd %SOURCE_DIR%
echo.
echo *** msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln /t:Build /m /nologo /v:m /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET% /p:BuildProjectReferences=false /p:OutDir=%PRODUCT_INSTALL%\
msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln  /t:Build /m /nologo /v:m /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET% /p:OutDir=%PRODUCT_INSTALL%\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)

REM Installation of additional files
echo.
echo *** Installation of additional files
cd ..
xcopy /Y /I /E %SOURCE_DIR%\include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 3
)

copy /Y %SOURCE_DIR%\PC\pyconfig.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copy PC\pyconfig.h
    exit 4
)

xcopy /Y /I /E %SOURCE_DIR%\lib %PRODUCT_INSTALL%\lib
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
  copy /Y /B %PRODUCT_INSTALL%\libs\python36_d.lib %PRODUCT_INSTALL%\libs\python36.lib 
  copy /Y /B %PRODUCT_INSTALL%\libs\python_d.lib %PRODUCT_INSTALL%\libs\python.lib 
)

cd %PRODUCT_INSTALL%\

REM Add PIP support
set PYTHONHOME=%PRODUCT_INSTALL%
set PYTHON_ROOT_DIR=%PRODUCT_INSTALL%
set PYTHON_VERSION=3.6
set PATH=%PRODUCT_INSTALL%;%PATH%
set PATH=%PRODUCT_INSTALL%\lib;%PATH%
set PYTHON_INCLUDE=%PRODUCT_INSTALL%\include
set PYTHONPATH=%PRODUCT_INSTALL%\lib;%PYTHONPATH%
set PYTHONPATH=%PRODUCT_INSTALL%\lib\site-packages;%PYTHONPATH%
set PYTHONBIN=%PRODUCT_INSTALL%\python.exe
set PATH=%PRODUCT_INSTALL%\Scripts;%PATH%

%PRODUCT_INSTALL%\python.exe %SOURCE_DIR%\externals\pip-19.1.1\get-pip.py --force-reinstall --no-setuptools --no-wheel  --no-index --find-links=%SOURCE_DIR%\externals\pip-19.1.1

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
