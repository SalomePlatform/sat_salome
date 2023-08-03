@echo off

echo ##########################################################################
echo openturns %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)
SET PRODUCT_BUILD_TYPE=Release

REM TODO: NGH: not Tested yet
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

REM we don't install in python directory -> modify environment as described in INSTALL file
set PATH=%WINFLEX_ROOT_DIR%;%PATH%
SET PATH=%CWD%\bin;%PATH%
SET PYTHONPATH=%CWD%;%PYTHONPATH%
SET PYTHONPATH=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages;%PYTHONPATH%

GOTO:MAIN

:MODULE_BUILDER
    SETLOCAL ENABLEDELAYEDEXPANSION
    SET MODULE_NAME=%~1
    SET MODULE_SOURCE_DIR=%~2
    SET MODULE_BUILD_DIR=%~3
    SET MODULE_INSTALL_DIR=%~4
    SET X=%~5
    SET MODULE_CMAKE_OPTIONS=%X:'="%
    REM NGH: We replace ' with " -  we could of course parse the input.
    ECHO call MODULE_BUILDER for %MODULE_NAME%
    ECHO command line option: %MODULE_CMAKE_OPTIONS%
    REM TODO: NGH: not Tested yet
    if exist "%MODULE_BUILD_DIR%" rmdir /Q /S %MODULE_BUILD_DIR%
    mkdir %MODULE_BUILD_DIR%
    cd %MODULE_BUILD_DIR%

    echo.
    echo --------------------------------------------------------------------------
    echo *** %CMAKE_ROOT%\bin\cmake -G %CMAKE_GENERATOR%  %MODULE_CMAKE_OPTIONS% %MODULE_SOURCE_DIR%
    echo --------------------------------------------------------------------------
    %CMAKE_ROOT%\bin\cmake -G %CMAKE_GENERATOR% %MODULE_CMAKE_OPTIONS% %MODULE_SOURCE_DIR%
    if NOT %ERRORLEVEL% == 0 (
      echo ERROR on cmake
      exit 1
    )

    echo.
    echo --------------------------------------------------------------------------
    echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
    echo --------------------------------------------------------------------------
    msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 ALL_BUILD.vcxproj
    if NOT %ERRORLEVEL% == 0 (
      echo ERROR on msbuild ALL_BUILD.vcxproj
      exit 2
    )

    echo.
    echo --------------------------------------------------------------------------
    echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
    echo --------------------------------------------------------------------------

    msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
    if NOT %ERRORLEVEL% == 0 (
      echo ERROR on msbuild INSTALL.vcxproj
      exit 3
    )
    ENDLOCAL
EXIT /B 0


:MAIN

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_EXECUTABLE=%SWIG_ROOT_DIR:\=/%/bin/swig
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTBB_ROOT_DIR=%TBB_ROOT_DIR%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dtbb_DIR:PATH=%TBB_ROOT_DIR:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_TBB=OFF
REM libxml2 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_INCLUDE_DIR:STRING=%LIBXML2_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARIES:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_XMLLINT_EXECUTABLE=%LIBXML2_ROOT_DIR:\=/%/bin/xmllint.exe

REM HDF5 settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_DIR:PATH=%HDF5_ROOT_DIR:\=/%/cmake/hdf5
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_INCLUDE_DIRS:PATH=%HDF5_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_INCLUDE_DIRS:STRING=%NLOPT_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_LIBRARIES:STRING=%NLOPT_ROOT_DIR:\=/%/bin
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DNLOPT_DIR:STRING=%NLOPT_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCBLAS_DIR=%OPENBLAS_ROOT_DIR:\=/%/share/cmake/OpenBLAS
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_EXECUTABLE:FILEPATH=%PYTHON_ROOT_DIR:\=/%/python3.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPython3_INCLUDE_DIR:PATH=%PYTHON_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLAPACK_LIBRARIES:FILEPATH=%OPENBLAS_ROOT_DIR:\=/%/lib/openblas.lib  
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_SHARED_LINKER_FLAGS_RELEASE='/OPT:NOREF /INCREMENTAL:NO'
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_UNITY_BUILD=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_UNITY_BUILD_BATCH_SIZE=16 
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSWIG_COMPILE_FLAGS='/bigobj'
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_SPHINX=OFF

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
mkdir cache
mkdir cache\pip

echo ##########################################################################
echo openturns 1.20.1
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER openturns "%SOURCE_DIR%\openturns-1.20.1" "%BUILD_DIR%\openturns" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

set PATH=%PRODUCT_INSTALL%\bin;%PRODUCT_INSTALL%\lib;%PATH%
set PYTHONPATH=%PRODUCT_INSTALL%\lib\site-packages;%PYTHONPATH%

echo ##########################################################################
echo otagrum 0.6 [SKIPPED]
echo ##########################################################################
REM SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
REM CALL:MODULE_BUILDER otagrum "%SOURCE_DIR%\otagrum-0.6" "%BUILD_DIR%\otagrum" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otmorris 0.13
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER otmorris "%SOURCE_DIR%\otmorris-0.13" "%BUILD_DIR%\otmorris" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otfftw 0.12
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER otfftw "%SOURCE_DIR%\otfftw-0.12" "%BUILD_DIR%\otfftw" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otmixmod 0.13 [SKIPPED]
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
REM CALL:MODULE_BUILDER otmixmod "%SOURCE_DIR%\otmixmod-0.13" "%BUILD_DIR%\otmixmod" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otpmml 1.12
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otpmml "%SOURCE_DIR%\otpmml-1.12" "%BUILD_DIR%\otpmml" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otrobopt 0.11
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otrobopt "%SOURCE_DIR%\otrobopt-0.11" "%BUILD_DIR%\otrobopt" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otsubsetinverse 1.9
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otsubsetinverse "%SOURCE_DIR%\otsubsetinverse-1.9" "%BUILD_DIR%\otsubsetinverse" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otsvm 0.11
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otsvm "%SOURCE_DIR%\otsvm-0.11" "%BUILD_DIR%\otsvm" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otfmi 0.15
echo ##########################################################################
cd %BUILD_DIR%
mkdir otfmi

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otfmi
xcopy %SOURCE_DIR%\otfmi-0.15\*   %BUILD_DIR%\otfmi /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo ##########################################################################
echo scikit-learn 0.24.2
echo ##########################################################################
cd %BUILD_DIR%
mkdir scikit-learn
cd  %BUILD_DIR%\scikit-learn
xcopy %SOURCE_DIR%\scikit-learn-0.24.2\*   %BUILD_DIR%\scikit-learn /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe -m pip install --cache-dir=%BUILD_DIR%\cache\pip --prefix=%PRODUCT_INSTALL% scikit-learn-0.24.2.tar.gz --no-deps --no-use-pep517
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo ##########################################################################
echo decorator 5.1.0
echo ##########################################################################
cd %BUILD_DIR%
mkdir decorator
cd  %BUILD_DIR%\decorator
xcopy %SOURCE_DIR%\decorator-5.1.0\*   %BUILD_DIR%\decorator /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe -m pip install --cache-dir=%BUILD_DIR%\cache\pip --prefix=%PRODUCT_INSTALL% decorator-5.1.0-py3-none-any.whl --no-deps
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo ##########################################################################
echo threadpoolctl 3.0.0
echo ##########################################################################
cd %BUILD_DIR%
mkdir threadpoolctl
cd  %BUILD_DIR%\threadpoolctl
xcopy %SOURCE_DIR%\threadpoolctl-3.0.0\*   %BUILD_DIR%\threadpoolctl /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe -m pip install --cache-dir=%BUILD_DIR%\cache\pip --prefix=%PRODUCT_INSTALL% threadpoolctl-3.0.0-py3-none-any.whl --no-deps
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo ##########################################################################
echo joblib 1.1.0
echo ##########################################################################
cd %BUILD_DIR%
mkdir joblib
cd  %BUILD_DIR%\joblib
xcopy %SOURCE_DIR%\joblib-1.1.0\*   %BUILD_DIR%\joblib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe -m pip install --cache-dir=%BUILD_DIR%\cache\pip --prefix=%PRODUCT_INSTALL% joblib-1.1.0-py2.py3-none-any.whl --no-deps
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo ##########################################################################
echo otpod 0.6.9
echo ##########################################################################
cd %BUILD_DIR%
mkdir otpod

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otpod
xcopy %SOURCE_DIR%\otpod-0.6.9\*   %BUILD_DIR%\otpod /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo ##########################################################################
echo otwrapy 0.11
echo ##########################################################################
cd %BUILD_DIR%
mkdir otwrapy

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otwrapy
xcopy %SOURCE_DIR%\otwrapy-0.11\*   %BUILD_DIR%\otwrapy /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo "########## END"
