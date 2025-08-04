#!/bin/bash

echo "##########################################################################"
echo "qwt" $VERSION
echo "##########################################################################"



export TMAKEPATH=${QTDIR}/bin
export PATH=${TMAKEPATH}:${PATH}

echo
echo "*** copy source"
mkdir -p ${PRODUCT_INSTALL}
#cp -r $SOURCE_DIR/* .
cd $SOURCE_DIR

QMAKE_BIN=qmake
if [ "$SAT_qt_IS_NATIVE" == "1" ]; then
    LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
    case $LINUX_DISTRIBUTION in
        FD3*|FD4*|CO10)
            QMAKE_BIN=$(which qmake-qt5)
            ;;
        *)
            echo "WARNING: using QMAKE_BIN = ${QMAKE_BIN}"
            ;;
    esac
fi

echo
echo "*** prepare $QMAKE_BIN"
sed -i "s|\(QWT_INSTALL_PREFIX[[:space:]]*\)=\([[:space:]]*\)\(.*\)|\1=\2${PRODUCT_INSTALL}|g" qwtconfig.pri
sed -i "s|#\(CONFIG[[:space:]]*+=[[:space:]]*QwtSVGItem\)|\1|g" qwtconfig.pri

sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/plugins/designer|g" designer/designer.pro 

echo
echo "** $QMAKE_BIN"
$QMAKE_BIN
if [ $? -ne 0 ]
then
    echo "ERROR on $QMAKE_BIN"
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

