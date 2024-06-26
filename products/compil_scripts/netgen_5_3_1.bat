@echo off

echo ##########################################################################
echo NETGEN %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
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
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_ROOT_DIR=%ZLIB_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCASROOT=%CASROOT%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR% -A x64
set MSBUILDDISABLENODEREUSE=1

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

copy /B /Y nglib\%PRODUCT_BUILD_TYPE%\*.exe %PRODUCT_INSTALL%\bin\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install executables
    exit 3
)

copy /B /Y nglib\%PRODUCT_BUILD_TYPE%\*.lib %PRODUCT_INSTALL%\lib\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install static libraries 
    exit 4
)

copy /B /Y nglib\%PRODUCT_BUILD_TYPE%\*.dll %PRODUCT_INSTALL%\lib\
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install dynamic libraries
    exit 4
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\meshing\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install meshing includes
    exit 5
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\gprim\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install gprim includes
    exit 6
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\general\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install general includes
    exit 7
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\linalg\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install linalg includes
    exit 8
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\occ\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install occ includes
    exit 9
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\include\mydefs.hpp %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install mydefs.hpp
    exit 10
)
xcopy /Q /R /Y %SOURCE_DIR%\libsrc\include\mystdlib.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install mystdlib.h
    exit 11
)
xcopy /Q /R /Y %SOURCE_DIR%\libsrc\include\nginterface.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nginterface.h
    exit 12
)
xcopy /Q /R /Y %SOURCE_DIR%\libsrc\include\nginterface_V2.hpp %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nginterface_V2.hpp
    exit 13
)

xcopy /Q /R /Y %SOURCE_DIR%\nglib\nglib.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install nglib.h
    exit 14
)

xcopy /Q /R /Y %SOURCE_DIR%\libsrc\stlgeom\*.h* %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install stlgeom
    exit 15
)

xcopy /Q /R /Y %SOURCE_DIR%\cmake\*.cmake %PRODUCT_INSTALL%\cmake
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on install cmake files
    exit 16
)

taskkill /F /IM "mspdbsrv.exe"


echo.
echo ########## END
