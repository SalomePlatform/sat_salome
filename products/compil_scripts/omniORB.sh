#!/bin/bash

echo "##########################################################################"
echo "omniORB" $VERSION
echo "##########################################################################"

PYTHON_HOME=$PYTHONHOME

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** configure --prefix=$PRODUCT_INSTALL --disable-ipv6"
PYTHON=$PYTHONBIN $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --disable-ipv6
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

function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

if version_ge $VERSION "4.1" ; then
    # fix headers
    echo
    echo "*** fix headers"
    cd $PRODUCT_INSTALL/bin
    pyVersionMajor=python$($PYTHONBIN -c 'import sys; print(".".join(map(str, sys.version_info[0:1])))')
    if [ $? -ne 0 ]; then
	      echo ERROR: Failed to extract major Python version -  assuming Python version equal to 3...
	      pyVersionMajor=python3
    elif [ "${pyVersionMajor}" == "python2" ]; then
	      pyVersionMajor=python
    fi
    echo INFO: Python version major: ${pyVersionMajor}
    sed -e "s%#\!.*python[0-9]*%#\!/usr/bin/env ${pyVersionMajor}%" omniidl > _omniidl
    mv -f _omniidl omniidl
    chmod a+x omniidl
    sed -e "s%#\!.*python[0-9]*%#\!/usr/bin/env ${pyVersionMajor}%" omniidlrun.py > _omniidlrun.py
    mv -f _omniidlrun.py omniidlrun.py
    chmod a+x omniidlrun.py
fi

cd $PRODUCT_INSTALL/lib
find . -name "*.so*" |xargs chmod u+rwx 

echo
echo "########## END"

