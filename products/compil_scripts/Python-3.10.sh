#!/bin/bash

echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

rm -rf $BUILD_DIR; mkdir $BUILD_DIR; cd $BUILD_DIR

if [ ${#VERSION} -lt 5 ]; then
    echo "ERROR : VERSION argument of Python compilation script has not the expected x.y.z format"
    exit 1
fi

IFS='.' read -r -a PYTHON_VERSION_SPLIT <<< "$VERSION"
PYTHON_VERSION="${PYTHON_VERSION_SPLIT[0]}.${PYTHON_VERSION_SPLIT[1]}"

# --enable-shared   : enable building shared python library
# --with-threads    : enable thread support
# --without-pymalloc: disable specialized mallocs
# --with-ensurepip  : installation using bundled pip
# --enable-optimizations:  recommandé et utilisé par Nijni -> mais trop long!
CONFIGURE_ARGUMENTS="--enable-shared --with-threads"
CONFIGURE_ARGUMENTS+=" --with-ensurepip=upgrade --with-pymalloc"

if [ -n "$OPENSSL_DIR" ]; then 
    CONFIGURE_ARGUMENTS+=" --with-openssl=$OPENSSL_DIR"
else
    CONFIGURE_ARGUMENTS+=" --with-ssl --enable-loadable-sqlite-extensions"
fi

opts=()
if [ "$DIST_NAME" = "macOS" ]; then
    CONFIGURE_ARGUMENTS+=" --build=arm64-apple-darwin --host=arm64-apple-darwin"
    eval "opts=($SAT_CONFIGURE_OPTIONS)"
    export ac_cv_func_pipe2=no
    export CC=clang
fi

echo
echo   "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS "${opts[@]}"
if [ $? -ne 0 ] ; then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ] ; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ] ; then
    echo "ERROR on make install"
    exit 3
fi

LIBPYTHON=libpython${PYTHON_VERSION}.so

if [ "$DIST_NAME" = "macOS" ]; then
    LIBPYTHON=libpython${PYTHON_VERSION}.dylib
fi

cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}*
if [ ! -e "$LIBPYTHON" ]; then
    echo
    echo "*** create missing link"
    if ! ln -sf ../../"$LIBPYTHON" .; then
        echo "ERROR when creating missing link"
        # no error here
    fi
fi

cd ${PRODUCT_INSTALL}/bin
ln -s python3 python
ln -s pip3 pip

if [ "${SAT_ENABLE_PYTHON_PYMALLOC}" == "1" ]; then
    cd ${PRODUCT_INSTALL}/include
    if [ ! -d python${PYTHON_VERSION} ]; then
	ln -s python${PYTHON_VERSION}m python${PYTHON_VERSION}
    fi
fi

# fix the path... 
L="2to3  2to3-${PYTHON_VERSION} easy_install-${PYTHON_VERSION} idle3 idle${PYTHON_VERSION} pip3 pip${PYTHON_VERSION} pydoc3 pydoc${PYTHON_VERSION} pyvenv pyvenv-${PYTHON_VERSION}"
cd ${PRODUCT_INSTALL}/bin
for f in  $L; do
    awk '$0 = NR==1 ? replace : $0' replace="#!/usr/bin/env python3" $f > $f.t && mv $f.t $f && chmod 755 $f
done

echo
echo "########## END"

