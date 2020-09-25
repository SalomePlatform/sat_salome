#!/bin/bash

echo "##########################################################################"
echo "qwt" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* .

export TMAKEPATH=${QTDIR}/bin
export PATH=${TMAKEPATH}:${PATH}

echo
echo "*** copy source"
mkdir -p ${PRODUCT_INSTALL}

echo
echo "*** prepare qmake"
sed -i "s|\(INSTALLBASE[[:space:]]*\)=\([[:space:]]*\)\(.*\)|\1=\2${PRODUCT_INSTALL}|g" qwtconfig.pri
sed -i "s|#\(CONFIG[[:space:]]*+=[[:space:]]*QwtSVGItem\)|\1|g" qwtconfig.pri

sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$INSTALLBASE/plugins/designer|g" designer/designer.pro 

echo
echo "** qmake"
qmake
if [ $? -ne 0 ]
then
    echo "ERROR on qmake"
    exit 1
fi

echo
echo "*** make"
make 
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

echo
echo "########## END"


