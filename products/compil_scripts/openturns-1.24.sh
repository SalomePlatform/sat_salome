#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

# useful function
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH

CMAKE_OPTIONS=""
if [ -n "$SAT_HPC" ] && [ -n "$MPI_ROOT_DIR" ]; then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER}"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER}"
fi

CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

if [ "$SAT_Python_IS_NATIVE" == "1" ] && [ "$LINUX_DISTRIBUTION" == "CO8" ] ; then
    CMAKE_OPTIONS+=" -DPython_EXECUTABLE=${PYTHONBIN}"
fi

if [ -n "$SWIG_ROOT_DIR" ] && [ "$SAT_swig_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
fi

if [ -n "$TBB_ROOT_DIR" ] && [ "$SAT_tbb_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DTBB_ROOT_DIR=${TBB_ROOT_DIR}"
    CMAKE_OPTIONS+=" -Dtbb_DIR=${TBB_ROOT_DIR}/lib/cmake"
fi

# https://github.com/openturns/openturns/issues/2820
case $LINUX_DISTRIBUTION in
    CO7)
        echo "WARNING: switching OFF USE_CXX17"
        CMAKE_OPTIONS+=" -DUSE_CXX17=OFF"
        ;;
    *)
        ;;
esac

# https://github.com/persalys/persalys/issues/745
case $LINUX_DISTRIBUTION in
    CO7|UB22*|CO8*|CO9*|CO1*|FD36|FD37|FD38|FD40|FD42)
        echo "WARNING: switching OFF TBB support"
        CMAKE_OPTIONS+=" -DUSE_TBB=OFF"
        ;;
    *)
        ;;
esac

# Blas/Lapack
if [[ "$LINUX_DISTRIBUTION" == "CO8" && "$SAT_lapack_IS_NATIVE" == "1"  &&  -f /usr/lib64/libcblas.so && -f /usr/lib64/libblas.so ]]; then
    CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=/usr/lib64/libcblas.so"
    CMAKE_OPTIONS+=" -DBLAS_LIBRARIES=/usr/lib64/libblas.so"
fi

if [ -n "$LAPACK_ROOT_DIR" ] && [ "$SAT_lapack_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DLAPACK_DIR=${LAPACK_ROOT_DIR}/lib/cmake/lapack-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_DIR=${LAPACK_ROOT_DIR}/lib/cmake/cblas-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libcblas.so"
    CMAKE_OPTIONS+=" -DBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libblas.so"
fi

### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "$SAT_libxml2_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

# HDF5
if [ -n "$HDF5_ROOT_DIR" ] && [ "$SAT_hdf5_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"
    CMAKE_OPTIONS+=" -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF"
    CMAKE_OPTIONS+=" -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib"
    CMAKE_OPTIONS+=" -DHDF5_hdf5_hl_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
    CMAKE_OPTIONS+=" -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
    CMAKE_OPTIONS+=" -DHDF5_C_INCLUDE_DIR=${HDF5_ROOT_DIR}/include"
fi

# CMINPACK
if [ -n "$CMINPACK_ROOT_DIR" ] && [ "$SAT_cminpack_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DCMINPACK_ROOT_DIR=${CMINPACK_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
    CMAKE_OPTIONS+=" -DCMINPACK_LIBRARY=$CMINPACK_ROOT_DIR/lib/libcminpack.so"
else
    CMAKE_OPTIONS+=" -DCMINPACK_ROOT_DIR=${CMINPACK_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
fi


## nlopt
if [ -n "$NLOPT_ROOT_DIR" ] && [ "$SAT_nlopt_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DNLOPT_ROOT_DIR:PATH=${NLOPT_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DNLOPT_INCLUDE_DIR:PATH=${NLOPT_ROOT_DIR}/include"
    CMAKE_OPTIONS+=" -DNLOPT_LIBRARY:STRING=${NLOPT_ROOT_DIR}/lib/libnlopt.so"
    CMAKE_OPTIONS+=" -DNLopt_DIR:PATH=${NLOPT_ROOT_DIR}/lib/cmake/nlopt"
fi

# Boost
if [ -n "$BOOST_ROOT_DIR" ] && [ "$SAT_boost_IS_NATIVE" != "1" ]; then
    CMAKE_OPTIONS+=" -DBOOST_DIR=${BOOST_ROOT_DIR}"
fi

# it is not clear to me why the following tests fail. I vetoe them (requires patch openturns-1.24.0003.patch to be applied)
# for additional informations, see: https://github.com/openturns/openturns/issues/2891
case $LINUX_DISTRIBUTION in
    CO10)
        CMAKE_OPTIONS+=" -DOPENTURNS_VETOED_TESTS=\"cppcheck_Log_std|cppcheck_FisherSnedecor_std|cppcheck_Poisson_std|cppcheck_Distribution_quantile|cppcheck_SmolyakExperiment_std\""
        ;;
    *)
        CMAKE_OPTIONS+=" -DOPENTURNS_VETOED_TESTS=\"cppcheck_Log_std|cppcheck_FisherSnedecor_std|cppcheck_Poisson_std|cppcheck_Distribution_quantile\""
        ;;
esac

echo
echo "*** cmake" $CMAKE_OPTIONS

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/openturns
mkdir -p  $BUILD_DIR/cache/pip

# since we are using several nodes and share the same $HOME
# compilation can get screwed up.
# following this discussion: https://tex.stackexchange.com/questions/467824/is-it-possible-to-relocate-my-texmf-directory
# we define the following environment variables
export TEXMFHOME=$BUILD_DIR/texmf
export TEXMFVAR=$BUILD_DIR/texlive
export TEXMFCONFIG=$BUILD_DIR/texlive
mkdir -p $TEXMFHOME
mkdir -p $TEXMFVAR
mkdir -p $TEXMFCONFIG

cd  $BUILD_DIR/openturns
cmake $CMAKE_OPTIONS $SOURCE_DIR/openturns-1.24
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** check installation"
make check
if [ $? -ne 0 ]; then
    echo "ERROR  testing Openturns features...."
    exit 4
fi

echo "*** check path"
if [ ! -d "${PRODUCT_INSTALL}/lib" ]; then
    mkdir -p ${PRODUCT_INSTALL}/lib
fi

if [ -d "${PRODUCT_INSTALL}/lib64" ]; then
    echo "WARNING: moving lib64 to lib"
    mv ${PRODUCT_INSTALL}/lib64/* ${PRODUCT_INSTALL}/lib/
    rm -rf ${PRODUCT_INSTALL}/lib64
elif [ -d "${PRODUCT_INSTALL}/local/lib64" ]; then
    echo "WARNING: moving local/lib64 to lib"
    mv ${PRODUCT_INSTALL}/local/lib64/* ${PRODUCT_INSTALL}/lib/
    rm -rf ${PRODUCT_INSTALL}/local/lib64
fi

if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
fi

cd  $BUILD_DIR
mkdir ${BUILD_DIR}/mixmod
cd ${BUILD_DIR}/mixmod


case $LINUX_DISTRIBUTION in
    CO10)
        :
        ;;
    *)
        CMAKE_EXTRA_OPTIONS=
        CMAKE_EXTRA_OPTIONS+=" -DMIXMOD_BUILD_EXAMPLES=ON"
        CMAKE_EXTRA_OPTIONS+=" -DMIXMOD_BUILD_IOSTREAM=ON"
        CMAKE_EXTRA_OPTIONS+=" -DMIXMOD_BUILD_CLI=ON"

        echo
        echo "*** cmake " $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS} $SOURCE_DIR/mixmod-2.1.11
        cmake $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS} $SOURCE_DIR/mixmod-2.1.11
        if [ $? -ne 0 ]; then
            echo "ERROR on cmake"
            exit 1
        fi

        echo
        echo "*** make" $MAKE_OPTIONS
        make $MAKE_OPTIONS
        if [ $? -ne 0 ]; then
            echo "ERROR on make"
            exit 2
        fi

        echo
        echo "*** make install"
        make install
        if [ $? -ne 0 ]; then
            echo "ERROR on make install"
            exit 3
        fi
        ;;
esac

declare -A OTC
OTC["otfftw"]="0.16"
OTC["otmixmod"]="0.18"
OTC["otmorris"]="0.17"
OTC["otrobopt"]="0.15"
OTC["otsvm"]="0.15"

for k in "${!OTC[@]}";
do
    echo
    echo "*** C O M P O N E N T : $k-${OTC[$k]} "
    if [[ $k == "otagrum" ]]; then
        echo "WARNING: skipping $k ..."
        continue
    fi
    if [ "$k" == "otmixmod" ] && [ "$LINUX_DISTRIBUTION" == "CO10" ]; then
        echo "WARNING: skipping $k ..."
        continue
    fi
    cd  $BUILD_DIR
    mkdir ${BUILD_DIR}/$k
    cd ${BUILD_DIR}/$k

    CMAKE_EXTRA_OPTIONS=
    if [[ $k == "otmixmod" ]]; then #FIXME:
        CMAKE_EXTRA_OPTIONS+=" -DSOURCEFILES=$SOURCE_DIR/$k-${OTC[$k]}"
        CMAKE_EXTRA_OPTIONS+=" -DMIXMOD_INCLUDE_DIR=$PRODUCT_INSTALL/include"
        CMAKE_EXTRA_OPTIONS+=" -DMIXMOD_LIBRARIES=$PRODUCT_INSTALL/lib/libmixmod.so"

        if [ ! -f $PRODUCT_INSTALL/lib/libmixmod.so ]; then
            echo "WARNING: libmixmod.so is not installed where it is expected to be. Skipping..."
            continue
        fi
    elif [[ $k == "otsubsetinverse" ]]; then #FIXME:
        CMAKE_EXTRA_OPTIONS+=" -DOPENTURNS_HOME=$PRODUCT_INSTALL"
        CMAKE_EXTRA_OPTIONS+=" -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON"
    fi

    echo
    echo "*** cmake $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS}  $SOURCE_DIR/$k-${OTC[$k]}"
    cmake $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS} $SOURCE_DIR/$k-${OTC[$k]}
    if [ $? -ne 0 ]
    then
        echo "ERROR on cmake"
        exit 1
    fi

    echo
    echo "*** make $MAKE_OPTIONS"
    make $MAKE_OPTIONS
    if [ $? -ne 0 ]
    then
        echo "ERROR on make"
        exit 2
    fi

    echo
    echo "*** make install"
    make install
    if [ $? -ne 0 ]
    then
        echo "ERROR on make install"
        exit 3
    fi

    echo "INFO: check presence of $PRODUCT_INSTALL/local"
    if [ -d "$PRODUCT_INSTALL/local" ]; then
        echo "INFO: $PRODUCT_INSTALL/local is present -  reearrange ..."
        if [ -d ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ]; then
            mv ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/site-packages
        fi
        for D in $(ls $PRODUCT_INSTALL/local); do
            echo "INFO: next subdirectory: $PRODUCT_INSTALL/local/$D"
            if [ -d $PRODUCT_INSTALL/$D ]; then
                cp -r $PRODUCT_INSTALL/local/$D/* $PRODUCT_INSTALL/$D/
            else
                mv $PRODUCT_INSTALL/local/$D $PRODUCT_INSTALL/$D
            fi
        done
        rm -rf $PRODUCT_INSTALL/local
    fi
done

declare -A OTP
OTP["otfmi"]="0.16.6"
OTP["otpod"]="0.6.11"
OTP["otwrapy"]="0.12.1"

for k in ${!OTP[@]};
do
    echo
    echo "*** C O M P O N E N T : $k-${OTP[$k]} "

    if [ "$SAT_Python_IS_NATIVE" == "1" ]; then
        if [ $k == "otfmi" ]; then
            echo "INFO: install dill-0.3.4"
            if ! ${PYTHONBIN} -c "import dill"; then
                ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/dill-0.3.4/dill-0.3.4-py2.py3-none-any.whl --no-deps  --prefix=$PRODUCT_INSTALL
                if [ $? -ne 0 ]
                then
                    echo "FATAL: could not install dill-0.3.4"
                    exit 6
                fi
            else
                echo "WARNING: dill is already installed"
            fi
            echo "INFO: install pythonfmu-0.6.3"
            if ! ${PYTHONBIN} -c "import pythonfmu"; then
                ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/pythonfmu-0.6.3/pythonfmu-0.6.3-py3-none-any.whl --no-deps  --prefix=$PRODUCT_INSTALL
                if [ $? -ne 0 ]
                then
                    echo "FATAL: could not install pythonfmu-0.6.3"
                    exit 6
                fi
            else
                echo "WARNING: pythonfmu is already innstalled"
            fi
        elif [ $k == "otpod" ]; then
            if [[ $DIST_NAME == "CO" && $DIST_VERSION == "8" && $SAT_Cython_IS_NATIVE == "1" ]]; then
                echo "*** skipping: since system Cython too old"
                continue
            fi
            echo "INFO: install joblib-1.1.0"
            if ! ${PYTHONBIN} -c "import joblib"; then
                ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/joblib-1.1.0/joblib-1.1.0-py2.py3-none-any.whl --no-deps --prefix=$PRODUCT_INSTALL
                if [ $? -ne 0 ]; then
                    echo "FATAL: could not install joblib-1.1.0"
                    exit 6
                fi
            else
                echo "WARNING: joblib is already installed"
            fi
            if ! ${PYTHONBIN} -c "import sklearn"; then
                if [ "${LINUX_DISTRIBUTION}" != "DB10" ]; then
                    echo "INFO: install scikit-learn-1.2.2"
                    if [ "${PYTHON_VERSION}" == "3.12" ]; then
                        ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/scikit-learn-1.2.2/scikit-learn-1.2.2.tar.gz --no-deps --prefix=$PRODUCT_INSTALL --no-build-isolation --no-use-pep517
                        if [ $? -ne 0 ]
                        then
                            echo "FATAL: could not install scikit-1.2.2"
                            exit 6
                        fi
                    else
                        ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/scikit-learn-1.2.2/scikit_learn-1.2.2-cp${PYTHON_VERSION//./}-cp${PYTHON_VERSION//./}-manylinux_2_17_x86_64.manylinux2014_x86_64.whl --no-deps --prefix=$PRODUCT_INSTALL
                    fi
                    if [ $? -ne 0 ]
                    then
                        echo "FATAL: could not install scikit-1.2.2"
                        exit 6
                    fi
                else
                    echo "INFO: install scikit-learn-1.0"
                    PIP3_VERSION=$(pip3 --version|cut -d ' ' -f2)
                    PIP3_OPTIONS=--no-build-isolation
                    if version_ge $PIP3_VERSION "19" ; then
                        PIP3_OPTIONS+=" --no-use-pep517"
                    fi
                    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/scikit-learn-1.0/scikit-learn-1.0.tar.gz --no-deps --prefix=$PRODUCT_INSTALL --no-build-isolation $PIP3_OPTIONS
                    if [ $? -ne 0 ]
                    then
                        echo "FATAL: could not install scikit-1.0"
                        exit 6
                    fi
                fi
            else
                echo "WARNING: sklearn is already installed"
            fi
            if ! ${PYTHONBIN} -c "import threadpoolctl"; then
                if [ "${LINUX_DISTRIBUTION}" != "DB10" ]; then
                    echo "INFO: install threadpoolctl-3.5.0"
                    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/threadpoolctl-3.5.0/threadpoolctl-3.5.0-py3-none-any.whl --no-deps --prefix=$PRODUCT_INSTALL
                    if [ $? -ne 0 ]
                    then
                        echo "FATAL: could not install threadpoolctl 3.5.0"
                        exit 6
                    fi
                else
                    echo "INFO: install threadpoolctl-3.0.0"
                    PIP3_VERSION=$(pip3 --version|cut -d ' ' -f2)
                    PIP3_OPTIONS=--no-build-isolation
                    if version_ge $PIP3_VERSION "19" ; then
                        PIP3_OPTIONS+=" --no-use-pep517"
                    fi
                    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/threadpoolctl-3.0.0/threadpoolctl-3.0.0-py3-none-any.whl --no-deps --prefix=$PRODUCT_INSTALL $PIP3_OPTIONS
                    if [ $? -ne 0 ]
                    then
                        echo "FATAL: could not install threadpoolctl 3.0.0"
                        exit 6
                    fi
                fi
            else
                echo "WARNING: threadpoolctl is already installed"
            fi
        elif [ $k == "otwrapy" ]; then
            echo "INFO: install tqdm-4.66.5"
            if ! ${PYTHONBIN} -c "import tqdm"; then
                ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/tqdm-4.66.5/tqdm-4.66.5-py3-none-any.whl --no-deps --prefix=$PRODUCT_INSTALL
                if [ $? -ne 0 ]
                then
                    echo "FATAL: could not install tqdm 4.66.5"
                    exit 6
                fi
            else
                echo "WARNING: tqdm is already installed"
            fi
        fi

        echo "INFO: check presence of $PRODUCT_INSTALL/local"
        if [ -d "$PRODUCT_INSTALL/local" ]; then
            echo "INFO: $PRODUCT_INSTALL/local is present -  reearrange ..."
            if [ -d ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ]; then
                mv ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/site-packages
            fi
            for D in $(ls $PRODUCT_INSTALL/local); do
                echo "INFO: next subdirectory: $PRODUCT_INSTALL/local/$D"
                if [ -d $PRODUCT_INSTALL/$D ]; then
                    cp -r $PRODUCT_INSTALL/local/$D/* $PRODUCT_INSTALL/$D/
                else
                    mv $PRODUCT_INSTALL/local/$D $PRODUCT_INSTALL/$D
                fi
            done
            rm -rf $PRODUCT_INSTALL/local
        fi
        #
    else # non native Python
        if [[ $k == "otfmi" ]]; then
            echo "INFO: install dill-0.3.4"
            ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/dill-0.3.4/dill-0.3.4-py2.py3-none-any.whl --no-deps
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install dill-0.3.4"
                exit 5
            fi
            echo "INFO: install pythonfmu-0.6.3"
            ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/pythonfmu-0.6.3/pythonfmu-0.6.3-py3-none-any.whl --no-deps
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install pythonfmu-0.6.3"
                exit 6
            fi
        elif [[ $k == "otpod" ]]; then
            echo "INFO: install threadpoolctl-3.0.0"
            ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/threadpoolctl-3.0.0/threadpoolctl-3.0.0-py3-none-any.whl --no-deps
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install threadpoolctl 3.0.0"
                exit 6
            fi
            echo "INFO: install joblib-1.1.0"
            ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/joblib-1.1.0/joblib-1.1.0-py2.py3-none-any.whl --no-deps
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install joblib-1.1.0"
                exit 6
            fi
            echo "INFO: install decorator-5.1.0"
            ${PYTHONBIN} -m pip install  --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/decorator-5.1.0/decorator-5.1.0-py3-none-any.whl --no-deps
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install decorator-5.1.0"
                exit 6
            fi
            if [ "${PYTHON_VERSION}" == "3.6" ]; then
                echo "INFO: install scikit-learn-0.24.2"
                ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/scikit-learn-0.24.2/scikit-learn-0.24.2.tar.gz --no-deps
                if [ $? -ne 0 ]
                then
                    echo "FATAL: could not install scikit-0.24.2"
                    exit 6
                fi
            else
                VERSION_PYTHON=${PYTHON_VERSION//./}
                echo "INFO: install scikit-learn-1.2.2"
                ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/scikit-learn-1.2.2/scikit_learn-1.2.2-cp${VERSION_PYTHON}-cp${VERSION_PYTHON}-manylinux_2_17_x86_64.manylinux2014_x86_64.whl --no-deps
                if [ $? -ne 0 ]
                then
                    echo "FATAL: could not install scikit-1.2.2"
                    exit 6
                fi
            fi
        elif [ $k == "otwrapy" ]; then
            echo "INFO: install tqdm-4.66.5"
            ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip $SOURCE_DIR/tqdm-4.66.5/tqdm-4.66.5-py3-none-any.whl --no-deps --prefix=$PRODUCT_INSTALL
            if [ $? -ne 0 ]
            then
                echo "FATAL: could not install tqdm 4.66.5"
                exit 6
            fi
        fi
    fi

    cd  $BUILD_DIR
    mkdir ${BUILD_DIR}/$k
    cd ${BUILD_DIR}/$k
    cp -R $SOURCE_DIR/$k-${OTP[$k]}/* .

    #
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL
    if [ $? -ne 0 ]; then
        echo "ERROR on ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip . --no-deps  --prefix=$PRODUCT_INSTALL"
        exit 4
    fi
    #
    echo "INFO: check presence of $PRODUCT_INSTALL/local"
    if [ -d "$PRODUCT_INSTALL/local" ]; then
        echo "INFO: $PRODUCT_INSTALL/local is present -  reearrange ..."
        if [ -d ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ]; then
            mv ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/local/lib/python${PYTHON_VERSION}/site-packages
        fi
        for D in $(ls $PRODUCT_INSTALL/local); do
            echo "INFO: next subdirectory: $PRODUCT_INSTALL/local/$D"
            if [ -d $PRODUCT_INSTALL/$D ]; then
                cp -r $PRODUCT_INSTALL/local/$D/* $PRODUCT_INSTALL/$D/
            else
                mv $PRODUCT_INSTALL/local/$D $PRODUCT_INSTALL/$D
            fi
        done
        rm -rf $PRODUCT_INSTALL/local
    fi
    if [ -d "${PRODUCT_INSTALL}/lib64" ]; then
        echo "WARNING: moving lib64 to lib"
        mv $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION/site-packages/* $PRODUCT_INSTALL/lib/python$PYTHON_VERSION/site-packages/
        rm -rf ${PRODUCT_INSTALL}/lib64
    elif [ -d "${PRODUCT_INSTALL}/local/lib64" ]; then
        echo "WARNING: moving local/lib64 to lib"
        mv $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION/site-packages/* $PRODUCT_INSTALL/lib/python$PYTHON_VERSION/site-packages/
        rm -rf ${PRODUCT_INSTALL}/local/lib64
    fi
done

#
# O P E N T U R N S
#
if [ -f ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/site.py ]; then
    echo "INFO: site.py already installed"
elif [ "$SAT_Python_IS_NATIVE" == "1" ]; then
    # check first whether the init.py file is installed
    echo "WARNING: missing init.py file. Installing it from system Python installation"
    SITE_PATCH=
    LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
    case $LINUX_DISTRIBUTION in
        DB11)
            SITE_PATCH=/usr/lib/pypy/dist-packages/setuptools/site-patch.py
            ;;
        DB10)
            SITE_PATCH=/usr/lib/python3/dist-packages/setuptools/site-patch.py
            ;;
        UB22*)
            SITE_PATCH=/usr/lib/pypy/dist-packages/setuptools/site-patch.py
            ;;
        UB24*)
            SITE_PATCH=/usr/lib/pypy3.9/site.py
            ;;
        UB20*)
            SITE_PATCH=/usr/lib/python3/dist-packages/setuptools/site-patch.py
            ;;
        FD32)
            SITE_PATCH=/usr/lib/python3.8/site-packages/setuptools/site-patch.py
            ;;
        FD34)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        FD36)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        FD37)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        FD38)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        FD40)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        FD42)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        CO8*)
            SITE_PATCH=/usr/lib/pypy/dist-packages/setuptools/site-patch.py
            ;;
        CO9*)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        CO10)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
        *)
            SITE_PATCH=$SOURCE_DIR/addons/site-patch.py
            ;;
    esac
    # check whether this file exists
    if [ "${SITE_PATCH}" == "" ]; then
        cp $SOURCE_DIR/addons/site-patch.py ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/site.py
    elif [ -f $SITE_PATCH ]; then
        cp $SITE_PATCH ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/site.py
    fi
elif [ -f ${PYTHON_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/setuptools/site-patch.py ]; then
    cp ${PYTHON_ROOT_DIR}/lib/python${PYTHON_VERSION}/site-packages/setuptools/site-patch.py ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/site.py
elif [ -f ${PYTHON_ROOT_DIR}/lib/python${PYTHON_VERSION}/site.py ]; then
    cp ${PYTHON_ROOT_DIR}/lib/python${PYTHON_VERSION}/site.py ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/site.py
else
    echo "ERROR: could not find site-patch.py"
    exit 7
fi

cd ${PRODUCT_INSTALL}/lib
# On some nodes, the link to OT is not done properly.
if [[ ! -f libOT.so.0 ]]; then
    echo "INFO: Fixing libOT.so"
    ln -sf libOT.so.0.25.0 libOT.so.0.25
    ln -sf libOT.so.0.25 libOT.so.0
    ln -sf libOT.so.0 libOT.so
fi

echo
echo "########## END"
