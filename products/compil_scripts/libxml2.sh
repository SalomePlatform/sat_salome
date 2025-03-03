#!/bin/bash

echo "##########################################################################"
echo "libxml2" $VERSION
echo "##########################################################################"

cd $SOURCE_DIR

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** configure"
$SOURCE_DIR/configure --with-python=${PYTHON_ROOT_DIR} --prefix=$PRODUCT_INSTALL LDFLAGS=-L${PYTHON_ROOT_DIR}/lib
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
echo ${LD_LIBRARY_PATH}
make -d $MAKE_OPTIONS
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

#CNC 08/06/18 : this part of script is maybe obsolete?
# OP 04/04/2018 Not useful
#cd python
#echo
#echo "*** build python"
#CFLAGS=-I${PWD}/include ${PYTHON_ROOT_DIR}/bin/python ./setup.py build
#if [ $? -ne 0 ]
#then
#    echo "ERROR on python build"
#    exit 4
#fi
#
#echo
#echo "*** install python"
#CFLAGS=-I${PWD}/include ${PYTHON_ROOT_DIR}/bin/python ./setup.py install
#if [ $? -ne 0 ]
#then
#    echo "ERROR on python install"
#    exit 5
#fi

echo
echo "########## END"

