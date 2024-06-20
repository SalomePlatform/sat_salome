#!/bin/bash

echo "##########################################################################"
echo "Python" $VERSION
echo "##########################################################################"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

if [ ${#VERSION} -lt 5 ]; then
    echo "ERROR : VERSION argument of Python compilation script has not the expected x.y.z format"
    exit 1
fi
PYTHON_VERSION="${VERSION:0:3}"
PYTHON_VERSION_MAJ=${PYTHON_VERSION:0:1}

# --enable-shared   : enable building shared python library
# --with-threads    : enable thread support
# --without-pymalloc: disable specialized mallocs
# --with-ensurepip  : installation using bundled pip
# --enable-optimizations:  recommandé et utilisé par Nijni -> mais trop long!
CONFIGURE_ARGUMENTS="--enable-shared --with-threads --with-ensurepip=install --with-ssl --enable-loadable-sqlite-extensions  --enable-unicode=ucs4"
if [ "${SAT_ENABLE_PYTHON_PYMALLOC}" == "1" ]; then
	  CONFIGURE_ARGUMENTS+=" --with-pymalloc"
else
	  CONFIGURE_ARGUMENTS+=" --without-pymalloc"
fi

echo
echo   "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS
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

echo
echo "########## END"

