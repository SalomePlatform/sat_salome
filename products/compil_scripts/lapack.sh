#!/bin/bash

echo "##########################################################################"
echo "lapack" $VERSION
echo "##########################################################################"



#echo "copy file"
#cp make.inc.example make.inc

#mkdir -p $PRODUCT_INSTALL
#cp -rp $SOURCE_DIR/* $PRODUCT_INSTALL/


CMAKE_OPTIONS="$SOURCE_DIR"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_PREFIX=$PRODUCT_INSTALL"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_BUILD_TYPE=Release" 
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_CXX_FLAGS=-fPIC"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_C_FLAGS=-fPIC"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DUSE_OPTIMIZED_BLAS=OFF"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCBLAS=ON"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DLAPACKE=ON"

echo
echo "*** cmake ${CMAKE_OPTIONS}"
cmake ${CMAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** make  ${MAKE_OPTIONS}"
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"

make install

#cp lib/libblas.so $PRODUCT_INSTALL/lib/
#cp lib/liblapack.so $PRODUCT_INSTALL/lib/
#cp lib/libtmglib.so $PRODUCT_INSTALL/lib/

#ln -s $PRODUCT_INSTALL/lib/blas_LINUX.so $PRODUCT_INSTALL/lib/libblas.so
#ln -s $PRODUCT_INSTALL/lib/lapack_LINUX.so $PRODUCT_INSTALL/lib/liblapack.so

if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

# Ce lien est nécéssaire pour numpy, qui ne veut entendre parler que du fichier liblapack.so.3
# Nous n'avons pas trouvé de moyen d'obtenir ce fichier autrement
# Voir https://codev-tuleap.cea.fr/plugins/tracker/?aid=8084
# Mise en commentaire car plus necessaire (CLACLA)
#VERSION_MAJOR=${VERSION:0:1}
#cd $PRODUCT_INSTALL/lib && ln -s liblapack.so liblapack.so.$VERSION_MAJOR && ln -s libblas.so libblas.so.$VERSION_MAJOR

#if [ $? -ne 0 ]
#then
#    echo "ERROR on symbolic link"
#    exit 4
#fi

#echo
#echo "*** make"
#make blaslib
#if [ $? -ne 0 ]
#then
#    echo "ERROR on make"
#    exit 2
#fi

#make lapacklib
#if [ $? -ne 0 ]
#then
#    echo "ERROR on make"
#    exit 2
#fi
##ln -s blas_LINUX.a libblas.a
##ln -s lapack_LINUX.a liblapack.a

#ln -s librefblas.a libblas.a

# En attendant de comprendre pourquoi numpy cherche des .h dans lib au lieu d'include
# j'ajoute les .h dans lib a la main
cp $PRODUCT_INSTALL/include/*.h $PRODUCT_INSTALL/lib/.

echo
echo "########## END"

