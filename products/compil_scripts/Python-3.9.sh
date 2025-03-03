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

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

# --enable-shared   : enable building shared python library
# --with-threads    : enable thread support
# --without-pymalloc: disable specialized mallocs
# --with-ensurepip  : installation using bundled pip
# --enable-optimizations:  recommandé et utilisé par Nijni -> mais trop long!
CONFIGURE_ARGUMENTS="--enable-shared --with-threads --with-ensurepip=install --with-ssl --enable-loadable-sqlite-extensions --with-pymalloc"

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

cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}*

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
cd ${PRODUCT_INSTALL}/bin
ln -s python3 python
ln -s pip3 pip
#
if [ "${SAT_ENABLE_PYTHON_PYMALLOC}" == "1" ]; then
    cd ${PRODUCT_INSTALL}/include
    if [ ! -d python3.9 ]; then
	ln -s python3.9m python3.9
    fi
fi

# fix the path... 
L="2to3  2to3-3.9 easy_install-3.9 idle3 idle3.9 pip3 pip3.9 pydoc3 pydoc3.9 pyvenv pyvenv-3.9"
cd ${PRODUCT_INSTALL}/bin
for f in  $L; do
    awk '$0 = NR==1 ? replace : $0' replace="#!/usr/bin/env python3" $f > $f.t && mv $f.t $f && chmod 755 $f
done

echo
echo "########## END"

