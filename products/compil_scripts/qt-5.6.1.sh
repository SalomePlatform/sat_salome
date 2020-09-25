#!/bin/bash

echo "##########################################################################"
echo "Qt" $VERSION
echo "##########################################################################"



# OP 28/04/2017 Artifact 8644 : probleme de longueur sur certaines commandes
#                               de compilation Qt. On fait tout dans les sources
#CURRENT_DIR=`pwd`
cd $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on $SOURCE_DIR access"
    exit 1
fi

echo
echo "*** configure"
# OP 28/04/2017 Artifact 8644 : probleme de longueur sur certaines commandes
#                               de compilation Qt. On fait tout dans les sources
#CXXFLAGS="-fpermissive" $SOURCE_DIR/configure -prefix $PRODUCT_INSTALL -release -opensource -no-rpath \
#    -verbose -no-separate-debug-info -confirm-license -qt-libpng -qt-xcb -no-eglfs -dbus-runtime
CXXFLAGS="-fpermissive" ./configure -prefix $PRODUCT_INSTALL -release -opensource -no-rpath \
    -verbose -no-separate-debug-info -confirm-license -qt-libpng -qt-xcb -no-eglfs -dbus-runtime -skip qtwebengine
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
# OP 28/04/2017 Artifact 8644 : modification du numero d'erreur +
#                               repositionnement dans le repertoire d'origine
#    exit 1
#    cd $CURRENT_DIR
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    # OP 28/04/2017 Artifact 8644 : modification du numero d'erreur +
#                               repositionnement dans le repertoire d'origine
#    exit 2
#    cd $CURRENT_DIR
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    # OP 28/04/2017 Artifact 8644 : modification du numero d'erreur +
#                               repositionnement dans le repertoire d'origine
#    exit 3
#    cd $CURRENT_DIR
    exit 4
fi

# OP 04/03/2017 Artifact 8644 : ajout du make clean pour nettoyer les sources
echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]
then
    echo "ERROR on make clean"
# OP 04/05/2017 Artifact 8644 : repositionnement dans le repertoire d'origine
#    cd $CURRENT_DIR
    exit 5
fi

if [[ $BITS == "64" ]]
then
    echo "*** create link for lib64"
    cd $PRODUCT_INSTALL
# OP 04/05/2017 Artifact 8644 : verif de la bonne execution de la commande
    if [ $? -ne 0 ]
    then
        echo "ERROR on $PRODUCT_INSTALL access"
        exit 6
    fi
    ln -s lib lib64
    # OP 04/05/2017 Artifact 8644 : verif de la bonne execution de la commande
    if [ $? -ne 0 ]
    then
        echo "ERROR on create link for lib64 in $PRODUCT_INSTALL"
        exit 7
    fi
fi

echo
echo "########## END"

