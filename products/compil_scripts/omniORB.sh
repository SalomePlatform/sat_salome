#!/bin/bash

echo "##########################################################################"
echo "omniORB" $VERSION
echo "##########################################################################"



PYTHON_HOME=$PYTHONHOME

echo
echo "*** configure --disable-ipv6"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --disable-ipv6 
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

if [[ $VERSION == "4.1.6" ]]
then
    # fix headers
    echo
    echo "*** fix headers"
    cd $PRODUCT_INSTALL/bin
    sed -e "s%#\!.*python%#\!/usr/bin/env python%" omniidl > _omniidl
    mv -f _omniidl omniidl
    chmod a+x omniidl
    sed -e "s%#\!.*python%#\!/usr/bin/env python%" omniidlrun.py > _omniidlrun.py
    mv -f _omniidlrun.py omniidlrun.py
    chmod a+x omniidlrun.py
fi

echo
echo "########## END"

