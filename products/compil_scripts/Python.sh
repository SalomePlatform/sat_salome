#!/bin/bash

echo "##########################################################################"
echo "Python" $VERSION
echo "##########################################################################"

if [ ${#VERSION} -lt 5 ]
then
    echo "ERROR : VERSION argument of Python compilation script has not the expected x.y.z format"
    exit 1
fi
PYTHON_VERSION="${VERSION:0:3}"
PYTHON_VERSION_MAJ=${PYTHON_VERSION:0:1}


function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }
if version_ge $VERSION "3.6"; then
    echo "*** Python version is newer than version 3.6 ..."
    # --enable-shared   : enable building shared python library
    # --with-threads    : enable thread support
    # --without-pymalloc: disable specialized mallocs
    # --with-ensurepip  : installation using bundled pip
    # --enable-optimizations:  recommandé et utilisé par Nijni -> mais trop long!
    CONFIGURE_ARGUMENTS="--enable-shared --with-threads --without-pymalloc --with-ensurepip=install --with-ssl --enable-loadable-sqlite-extensions"
else
    echo "*** Python version is older than version 3.6 ..."
    CONFIGURE_ARGUMENTS="--enable-shared --with-threads --without-pymalloc --enable-unicode=ucs4"
fi

echo
echo   "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
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

if [ ${PYTHON_VERSION_MAJ} == 3 ]
then
    # OP trick for Python 3.6.1
    #cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}
    cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}*
else
    cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config
fi

if [ ! -e libpython${PYTHON_VERSION}.so ]
then
    echo
    echo "*** create missing link"
    ln -sf ../../libpython${PYTHON_VERSION}.so .
    if [ $? -ne 0 ]
    then
        echo "ERROR when creating missing link"
        # no error here
    fi
fi
if [ ${PYTHON_VERSION_MAJ} == 3 ]
then
    cd ${PRODUCT_INSTALL}/bin
    ln -s python3 python
    ln -s pip3 pip
fi

# fix the path... 
if version_ge $VERSION "3.6"; then
    L="2to3  2to3-3.6 easy_install-3.6 idle3 idle3.6 pip3 pip3.6 pydoc3 pydoc3.6 pyvenv pyvenv-3.6"
    cd ${PRODUCT_INSTALL}/bin
    for f in  $L; do
	awk '$0 = NR==1 ? replace : $0' replace="#!/usr/bin/env python3" $f > $f.t && mv $f.t $f && chmod 755 $f
    done
fi

echo
echo "########## END"

