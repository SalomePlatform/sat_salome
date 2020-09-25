@echo off

echo ##########################################################################
echo NETGEN %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
REM if %SAT_DEBUG% == 1 (
REM   set PRODUCT_BUILD_TYPE=Debug
REM )

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\cmake" mkdir %PRODUCT_INSTALL%\cmake

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

dos2unix -q %SOURCE_DIR%/libsrc/occ/*
dos2unix -q %SOURCE_DIR%/libsrc/occ/*
dos2unix -q %SOURCE_DIR%/libsrc/nglib/*

set CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
if defined CMAKE_GENERATOR (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%
) else (
    set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)
set MSBUILDDISABLENODEREUSE=1

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_ROOT_DIR=%ZLIB_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCASROOT=%CASROOT%

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake
    exit 1
)


echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake --build . --config %PRODUCT_BUILD_TYPE%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake --build . --config %PRODUCT_BUILD_TYPE%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake build
    exit 2
)


echo.
echo --------------------------------------------------------------------------
echo *** Installation into %PRODUCT_INSTALL%
echo --------------------------------------------------------------------------

robocopy nglib\%PRODUCT_BUILD_TYPE% %PRODUCT_INSTALL%\bin "*.exe" /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR on install executables
    exit 3
)

robocopy nglib\%PRODUCT_BUILD_TYPE% %PRODUCT_INSTALL%\lib "*.lib" "*.dll" /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR on install libraries
    exit 4
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\meshing\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install meshing includes
    exit 5
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\gprim\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install gprim includes
    exit 6
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\general\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install general includes
    exit 7
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\linalg\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install linalg includes
    exit 8
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\occ\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install occ includes
    exit 9
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\include\mydefs.hpp %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install mydefs.hpp
    exit 10
)
xcopy /q /r /Y %SOURCE_DIR%\libsrc\include\mystdlib.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install mystdlib.h
    exit 11
)
xcopy /q /r /Y %SOURCE_DIR%\libsrc\include\nginterface.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nginterface.h
    exit 12
)
xcopy /q /r /Y %SOURCE_DIR%\libsrc\include\nginterface_V2.hpp %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nginterface_V2.hpp
    exit 13
)

xcopy /q /r /Y %SOURCE_DIR%\nglib\nglib.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nglib.h
    exit 14
)

xcopy /q /r /Y %SOURCE_DIR%\libsrc\include\stlgeom.hpp %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install stlgeom
    exit 15
)

robocopy %SOURCE_DIR%\cmake %PRODUCT_INSTALL%\cmake "*.cmake" /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR on install cmake files
    exit 16
)
taskkill /F /IM "mspdbsrv.exe"


echo.
echo ########## END
