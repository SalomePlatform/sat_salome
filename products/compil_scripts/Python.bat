@echo off

echo ##########################################################################
echo Python %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\libs" mkdir %PRODUCT_INSTALL%\libs
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set buildConfiguration=Debug

SET MSBUILDDISABLENODEREUSE=1

SET TargetPlatformVersion=10.0.17134.0
cd %SOURCE_DIR%\PCbuild

REM Upgrade to current version of MSVC
echo.
echo *** devenv pcbuild.sln /upgrade
devenv pcbuild.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

cd %BUILD_DIR%

echo.
REM echo Extracting nasm...
7z x -y %SOURCE_DIR%\externals\zips\nasm-2.11.06.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-bin-deps-nasm-2.11.06 %SOURCE_DIR%\externals\nasm-2.11.06

REM echo Extracting openssl...
7z x -y %SOURCE_DIR%\externals\zips\openssl-1.0.2k.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-openssl-1.0.2k %SOURCE_DIR%\externals\openssl-1.0.2k

REM echo Extracting sqlite...
7z x -y %SOURCE_DIR%\externals\zips\sqlite-3.14.2.0.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-sqlite-3.14.2.0 %SOURCE_DIR%\externals\sqlite-3.14.2.0

REM echo Extracting xz...
7z x -y %SOURCE_DIR%\externals\zips\xz-5.2.2.zip -o%SOURCE_DIR%\externals
mv %SOURCE_DIR%\externals\cpython-source-deps-xz-5.2.2 %SOURCE_DIR%\externals\xz-5.2.2

REM Compilation

echo.
echo *** msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln /t:Build /m /nologo /v:m /p:Configuration=%buildConfiguration% /p:Platform=x64 /p:TargetPlatformVersion=%TargetPlatformVersion% /p:BuildProjectReferences=false
msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln  /t:Build /m /nologo /v:m /p:Configuration=%buildConfiguration% /p:Platform=x64 /p:TargetPlatformVersion=%TargetPlatformVersion%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)

REM Installation
echo.
echo *** msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln %MAKE_OPTIONS% %MAKE_OPTIONS% %LIST_OF_PROJECTS% /p:Configuration=%buildConfiguration% /p:Platform=x64 /p:TargetPlatformVersion=%TargetPlatformVersion% /p:BuildProjectReferences=false /p:OutDir=%PRODUCT_INSTALL%\ 
msbuild %SOURCE_DIR%\PCBuild\pcbuild.sln %MAKE_OPTIONS% /p:Configuration=%buildConfiguration% /p:Platform=x64 /p:TargetPlatformVersion=%TargetPlatformVersion% /p:OutDir=%PRODUCT_INSTALL%\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 3
)

REM Installation of additional files
echo.
echo *** Installation of additional files
cd ..
xcopy /i %SOURCE_DIR%\include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 4
)

copy %SOURCE_DIR%\PC\pyconfig.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copy PC\pyconfig.h
    exit 5
)

xcopy /i /e %SOURCE_DIR%\lib %PRODUCT_INSTALL%\lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy lib
    exit 6
)

xcopy /i %PRODUCT_INSTALL%\python3.lib %PRODUCT_INSTALL%\libs
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy python3.lib
    exit 7
)

xcopy /i %PRODUCT_INSTALL%\python36.lib %PRODUCT_INSTALL%\libs
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy python36.lib
    exit 8
)

robocopy %PRODUCT_INSTALL%\python.exe %PRODUCT_INSTALL%\python3.exe  /Y

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
