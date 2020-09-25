#!/bin/bash

echo "##########################################################################"
echo "graphviz" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* .

echo "graphviz compilation"
# tcl natif
if [ ${#TCLHOME} -eq 0 ]
then
    TCLHOME="/usr"
fi

echo
echo "*** configure"
if [ "`lsb_release -si``lsb_release -sr`"=="Fedora17" ]&&[ $VERSION=="2.28.0" ]
then
	# Fix compilation error graphviz 2.28.0 for Fedora17 (EXTERN.h not found)
    ./configure --prefix=${PRODUCT_INSTALL} --with-tcl=${TCLHOME}/lib --disable-rpath --with-expat=no --with-qt=no --with-cgraph=no --enable-python=no CPPFLAGS="-I/usr/lib64/perl5/CORE"
else
    ./configure --prefix=${PRODUCT_INSTALL} --with-tcl=${TCLHOME}/lib --disable-rpath --with-expat=no --with-qt=no --with-cgraph=no --enable-python=no # 13 mars 2013 ajout de "--with-cgraph=no" a cause d'un conflit avec YACS
fi
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" ${MAKE_OPTIONS}
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

