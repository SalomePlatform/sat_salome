@echo off

echo ##########################################################################
echo openturns %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

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
    if exist "%MODULE_BUILD_DIR%" rmdir /Q /S %MODULE_BUILD_DIR%
    mkdir %MODULE_BUILD_DIR%
    cd %MODULE_BUILD_DIR%

    echo.
    echo --------------------------------------------------------------------------
    echo *** %CMAKE_ROOT%\bin\cmake -G %CMAKE_GENERATOR%  -A x64 %MODULE_CMAKE_OPTIONS% %MODULE_SOURCE_DIR%
    echo --------------------------------------------------------------------------
    %CMAKE_ROOT%\bin\cmake -G %CMAKE_GENERATOR% -A x64 %MODULE_CMAKE_OPTIONS% %MODULE_SOURCE_DIR%
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

:WHEEL_INSTALLER
    SETLOCAL ENABLEDELAYEDEXPANSION
    SET WHEEL_NAME=%~1
    %PYTHON_ROOT_DIR%\python.exe -m pip install --cache-dir=%BUILD_DIR%\cache\pip --prefix=%PRODUCT_INSTALL% %WHEEL_NAME% --no-deps
    if NOT %ERRORLEVEL% == 0 (
      echo ERROR on pip install %WHEEL_NAME%
      exit 1
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
echo openturns 1.24
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER openturns "%SOURCE_DIR%\openturns-1.24" "%BUILD_DIR%\openturns" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

set PATH=%PRODUCT_INSTALL%\bin;%PRODUCT_INSTALL%\lib;%PATH%
set PYTHONPATH=%PRODUCT_INSTALL%\lib\site-packages;%PYTHONPATH%

echo ##########################################################################
echo otagrum 0.10 [SKIPPED]
echo ##########################################################################
REM SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
REM CALL:MODULE_BUILDER otagrum "%SOURCE_DIR%\otagrum-0.10" "%BUILD_DIR%\otagrum" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otmorris 0.17
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER otmorris "%SOURCE_DIR%\otmorris-0.17" "%BUILD_DIR%\otmorris" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otfftw 0.16
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
CALL:MODULE_BUILDER otfftw "%SOURCE_DIR%\otfftw-0.16" "%BUILD_DIR%\otfftw" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otmixmod 0.17 [SKIPPED]
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS%
REM CALL:MODULE_BUILDER otmixmod "%SOURCE_DIR%\otmixmod-0.17" "%BUILD_DIR%\otmixmod" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otrobopt 0.15
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otrobopt "%SOURCE_DIR%\otrobopt-0.15" "%BUILD_DIR%\otrobopt" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otsubsetinverse 1.10
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otsubsetinverse "%SOURCE_DIR%\otsubsetinverse-1.10" "%BUILD_DIR%\otsubsetinverse" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo ##########################################################################
echo otsvm 0.15
echo ##########################################################################
SET CMAKE_MODULE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_DOC=OFF
CALL:MODULE_BUILDER otsvm "%SOURCE_DIR%\otsvm-0.15" "%BUILD_DIR%\otsvm" "%PRODUCT_INSTALL%" "%CMAKE_MODULE_OPTIONS%"

echo
echo ##########################################################################
echo dill 0.3.4
echo ##########################################################################
cd %BUILD_DIR%
mkdir dill
cd  %BUILD_DIR%\dill
xcopy %SOURCE_DIR%\dill-0.3.4\*   %BUILD_DIR%\dill /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

call :WHEEL_INSTALLER dill-0.3.4-py2.py3-none-any.whl

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

call :WHEEL_INSTALLER decorator-5.1.0-py3-none-any.whl

echo
echo ##########################################################################
echo threadpoolctl 3.5.0
echo ##########################################################################
cd %BUILD_DIR%
mkdir threadpoolctl
cd  %BUILD_DIR%\threadpoolctl
xcopy %SOURCE_DIR%\threadpoolctl-3.5.0\*   %BUILD_DIR%\threadpoolctl /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

call :WHEEL_INSTALLER threadpoolctl-3.5.0-py3-none-any.whl

echo
echo ##########################################################################
echo joblib 1.4.2
echo ##########################################################################
cd %BUILD_DIR%
mkdir joblib
cd  %BUILD_DIR%\joblib
xcopy %SOURCE_DIR%\joblib-1.4.2\*   %BUILD_DIR%\joblib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

call :WHEEL_INSTALLER joblib-1.4.2-py3-none-any.whl

echo
echo ##########################################################################
echo seaborn 0.13.2
echo ##########################################################################
cd %BUILD_DIR%
mkdir seaborn
cd  %BUILD_DIR%\seaborn
xcopy %SOURCE_DIR%\seaborn-0.13.2\*   %BUILD_DIR%\seaborn /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

call :WHEEL_INSTALLER seaborn-0.13.2-py3-none-any.whl

echo ##########################################################################
echo ipython 8.18.1
echo ##########################################################################
cd %BUILD_DIR%
mkdir ipython
cd  %BUILD_DIR%\ipython
xcopy %SOURCE_DIR%\ipython-8.18.1\*   %BUILD_DIR%\ipython /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)


call :WHEEL_INSTALLER typing_extensions-4.12.2-py3-none-any.whl
call :WHEEL_INSTALLER traitlets-5.14.3-py3-none-any.whl
call :WHEEL_INSTALLER stack_data-0.6.3-py3-none-any.whl
call :WHEEL_INSTALLER prompt_toolkit-3.0.48-py3-none-any.whl
call :WHEEL_INSTALLER matplotlib_inline-0.1.7-py3-none-any.whl
call :WHEEL_INSTALLER jedi-0.19.1-py2.py3-none-any.whl
call :WHEEL_INSTALLER pure_eval-0.2.3-py3-none-any.whl
call :WHEEL_INSTALLER asttokens-2.4.1-py2.py3-none-any.whl
call :WHEEL_INSTALLER executing-2.1.0-py2.py3-none-any.whl
call :WHEEL_INSTALLER wcwidth-0.2.13-py2.py3-none-any.whl
call :WHEEL_INSTALLER parso-0.8.4-py2.py3-none-any.whl

tar zxf ipython-8.18.1.tar.gz
cd  ipython-8.18.1
%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo ##########################################################################
echo tqdm 4.66.5
echo ##########################################################################
cd %BUILD_DIR%
mkdir tqdm
cd  %BUILD_DIR%\tqdm
xcopy %SOURCE_DIR%\tqdm-4.66.5\*   %BUILD_DIR%\tqdm /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 3
)

call :WHEEL_INSTALLER tqdm-4.66.5-py3-none-any.whl

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

tar zxf scikit-learn-0.24.2.tar.gz
cd  scikit-learn-0.24.2
%PYTHON_ROOT_DIR%\python.exe setup.py install --prefix=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python setup.py
    exit 3
)

echo
echo ##########################################################################
echo pythonfmu 0.6.3
echo ##########################################################################
cd %BUILD_DIR%
mkdir pythonfmu
cd  %BUILD_DIR%\pythonfmu
xcopy %SOURCE_DIR%\pythonfmu-0.6.3\*   %BUILD_DIR%\pythonfmu /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy of pythonfmu-0.6.3
    exit 3
)

call :WHEEL_INSTALLER pythonfmu-0.6.3-py3-none-any.whl

echo ##########################################################################
echo otfmi 0.16.6
echo ##########################################################################
cd %BUILD_DIR%
mkdir otfmi

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otfmi
xcopy %SOURCE_DIR%\otfmi-0.16.6\*   %BUILD_DIR%\otfmi /E /I /Q
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
echo otpod 0.6.11
echo ##########################################################################
cd %BUILD_DIR%
mkdir otpod

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otpod
xcopy %SOURCE_DIR%\otpod-0.6.11\*   %BUILD_DIR%\otpod /E /I /Q
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
echo otwrapy 0.12.1
echo ##########################################################################
cd %BUILD_DIR%
mkdir otwrapy

set CMAKE_OPTIONS_EXT=%CMAKE_OPTIONS%
cd  %BUILD_DIR%\otwrapy
xcopy %SOURCE_DIR%\otwrapy-0.12.1\*   %BUILD_DIR%\otwrapy /E /I /Q
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
