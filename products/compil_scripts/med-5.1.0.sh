#!/bin/bash

echo "##########################################################################"
echo "med" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd $BUILD_DIR

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=' CFLAGS=-m64 CXXFLAGS=-m64' 
CONFIGURE_FLAGS+=' --enable-mesgerr'
CONFIGURE_FLAGS+=' --enable-installtest'

if [ -n "$SAT_HPC" ]; then
    export CXX=${MPI_CXX_COMPILER}
    export CC=${MPI_C_COMPILER}
    export FC=${MPI_Fortran_COMPILER}
    CONFIGURE_FLAGS+=' --enable-python=no'
else
    export F77=gfortran
    CONFIGURE_FLAGS+=' --enable-python=yes'
fi

if [ "$SALOME_USE_64BIT_IDS" == "1" ]; then
    echo "WARNING: user requested 64 bits encoding for integers..."
    export  FFLAGS="-g -O2 -ffixed-line-length-none -fdefault-integer-8"
    export FCFLAGS="-fdefault-integer-8"
    CONFIGURE_FLAGS+=' --with-med_int=long'
else
    export  FFLAGS="-g -O2 -ffixed-line-length-none"
    export FCFLAGS="-g -O2 -ffixed-line-length-none"
fi

if [ "${SAT_Python_IS_NATIVE}" != "1" ]; then
    CONFIGURE_FLAGS+=" --with-python_prefix=$PYTHON_ROOT_DIR"
fi

echo
echo "*** configure   --prefix=$PRODUCT_INSTALL FFLAGS=\"${FFLAGS}\"   FCFLAGS=\"${FCFLAGS}\"   $CONFIGURE_FLAGS"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL FFLAGS="${FFLAGS}"     FCFLAGS="${FCFLAGS}"     $CONFIGURE_FLAGS
if [ $? -ne 0 ]; then
    echo "ERROR on configure"
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

# post-build action in case devtoolset is used
LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
case $LINUX_DISTRIBUTION in
    CO7)
        if [ -n "$X_SCLS" ]
        then
            X_SCLSVALUE=$(echo $X_SCLS)
            if [  "devtoolset" =~ "$X_SCLSVALUE" ]; then
                echo "WARNING: devtoolset is installed on ${LINUX_DISTRIBUTION} - libgfortran will be embedded..."
                cp -RP /usr/lib64/libgfortran.so.5* $PRODUCT_INSTALL/lib/
            fi
        else
            echo "INFO: X_SCLS does not seem to be set. skipping..."
        fi
        ;;
    *)
        ;;
esac


#TODO: figure out which environment variable uses this dist-dir
if [ -d $PRODUCT_INSTALL/local/lib/python${PYTHON_VERSION} ]; then
    mv $PRODUCT_INSTALL/local/lib/python${PYTHON_VERSION} $PRODUCT_INSTALL/lib
fi
if [ -d $PRODUCT_INSTALL/local/bin ]; then
    mv $PRODUCT_INSTALL/local/bin/* $PRODUCT_INSTALL/bin
fi
if [ -d $PRODUCT_INSTALL/local/share ]; then
    mv $PRODUCT_INSTALL/local/share/* $PRODUCT_INSTALL/share
fi
if [ -d $PRODUCT_INSTALL/local ]; then
    rm -rf $PRODUCT_INSTALL/local
fi
if [ -d $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/dist-packages ]; then
    mv $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/dist-packages $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
fi

if [ -f /.dockerenv ]; then
    # allow running as root on a docker
    export OMPI_ALLOW_RUN_AS_ROOT=1
    export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
fi

echo
echo "*** make check"
make check
if [ $? -ne 0 ]; then
    echo "ERROR on make check"
    exit 4
fi

echo
echo "########## END"
