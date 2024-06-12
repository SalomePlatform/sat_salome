@echo off

echo ##########################################################################
echo Installing LATA %VERSION%
echo ##########################################################################

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

robocopy %SOURCE_DIR% %BUILD_DIR% /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when copying archive
    exit 1
)

REM LATA source directory
set LATA_SRC_DIR=%BUILD_DIR%\src

REM LATA binary directory
set LATA_BIN_DIR=%BUILD_DIR%\bin

REM build folder
mkdir %BUILD_DIR%\plugin_visit\build_paraview

REM copy the patched CMake file... caution, the patch is provided with the archive
copy %BUILD_DIR%\plugin_visit\CMakeLists.txt.para %BUILD_DIR%\plugin_visit\build_paraview\CMakeLists.txt
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying CMakeLists.txt
    exit 2
)

cd %BUILD_DIR%\plugin_visit\build_paraview

REM add required symbolic links
cp %BUILD_DIR%\plugin_visit\src\avtlataFileFormat.h avtlataFileFormat.h
cp %BUILD_DIR%\plugin_visit\src\avtlataFileFormat.C avtlataFileFormat.C 
for /r "%LATA_SRC_DIR%/commun_triou" %%G in (*.cpp) do COPY %%~G *.C
for /r "%LATA_SRC_DIR%/commun_triou" %%G in (*.h) do COPY %%~G *.h
for /r "%LATA_SRC_DIR%/triou_compat" %%G in (*.h) do COPY %%~G *.h
for /r "%LATA_SRC_DIR%/triou_compat" %%G in (*.cpp) do COPY %%~G *.C

REM define the VISITLIBPATH variable
set VISITLIBPATH=%BUILD_DIR%\VisItLib

echo.
echo INFO: running cmake -DVisItBridgePlugin_SOURCE_DIR=%BUILD_DIR%\VisItLib

cd %BUILD_DIR%\build_paraview

SET CMAKE_OPTIONS=-DCMAKE_BUILD_TYPE:STRING=Release
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVisItBridgePlugin_SOURCE_DIR=%BUILD_DIR:\=/%/VisItLib 
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR% -A x64
cmake %CMAKE_OPTIONS%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR: failed to run command: cmake %CMAKE_OPTIONS%
    exit 1
)

echo.
echo INFO: fix file: vtkVisItReaderlataSM.xml
REM copy the patched CMake file... caution, the patch is provided with the archive
rm -f vtkVisItReaderlataSM.xml

cp %BUILD_DIR%\plugin_visit\vtkVisItReaderlataSM.xml.para vtkVisItReaderlataSM.xml

REM create a doc folder
mkdir %BUILD_DIR%\doc

echo.
echo "INFO: running command: make..."
msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo INFO: copy the shared objects library to the installation folder.
copy %BUILD_DIR%\libVisItReaderlata.dll %PRODUCT_INSTALL%\lib\libVisItReaderlata.dll
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying libVisItReaderlata.dll
    exit 2
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
