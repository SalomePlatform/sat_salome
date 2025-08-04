#!/bin/bash

echo "##########################################################################"
echo "FFTW" $VERSION
echo "##########################################################################"

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

CONFIGURE_OPTIONS=
if [ -n "${SAT_HPC}" ]; then
    CONFIGURE_OPTIONS+=" --enable-mpi"
fi

if [ -n "${SAT_DEBUG}" ]; then
    CONFIGURE_OPTIONS+=" --enable-debug"
fi

CFLAGS_OPTIONS=

echo
echo "*** configure --prefix=${PRODUCT_INSTALL} --enable-shared ${CONFIGURE_OPTIONS} CFLAGS=${CFLAGS_OPTIONS}"
${SOURCE_DIR}/configure --prefix=${PRODUCT_INSTALL} --enable-shared \
    ${CONFIGURE_OPTIONS} \
    CFLAGS=${CFLAGS_OPTIONS}

if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make"
make
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

echo
echo "########## END"
