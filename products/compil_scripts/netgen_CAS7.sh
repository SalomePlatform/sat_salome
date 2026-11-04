#!/bin/bash

echo "##########################################################################"
echo "netgen" $VERSION
echo "##########################################################################"



cp -r $SOURCE_DIR/* .

# Variable for Multithreading
export DISABLE_FPE=1
export MMGT_REENTRANT=1
export PATH=$CASROOT/inc:$CASROOT/include:$CASROOT/include/opencascade:${PATH}
export LD_LIBRARY_PATH=$CASROOT/lib:$CASROOT/lin64/gcc/lib:${LD_LIBRARY_PATH}
# Variable for 3D viewer
export CSF_ShadersDirectory=$CASROOT/share/opencascade/resources/Shaders/
# Variable for Foundation Classes :
export CSF_UnitsLexicon=$CASROOT/share/opencascade/resources/UnitsAPI/Lexi_Expr.dat
export CSF_UnitsDefinition=$CASROOT/share/opencascade/resources/UnitsAPI/Units.dat
# Variable for DataExchange :
export CSF_SHMessage=$CASROOT/share/opencascade/resources/SHMessage
export CSF_XSMessage=$CASROOT/share/opencascade/resources/XSMessage
# Variable for Font :
#export CSF_MDTVFontDirectory=$CASROOT/src/FontMFT
export CSF_MDTVTexturesDirectory=$CASROOT/share/opencascade/resources/Textures
# library tcl/tk et tix
export TCL_LIBRARY=${TCLHOME}
export TK_LIBRARY=${TCLHOME}
export TIX_LIBRARY=${TCLHOME}

echo
echo "*** configure"
BFLAG="-m64"


echo ./configure --prefix=${PRODUCT_INSTALL} \
    --with-occ=${CASROOT} \
    --with-tcl=${TCLHOME}/lib \
    --with-tk=${TCLHOME}/lib \
    --with-tclinclude=${TCLHOME}/include \
    #--with-togl=${TCLHOME}/lib \
    #LDFLAGS="-L${TCLHOME}/lib" \
    #CPPFLAGS="-I${TCLHOME}/include" \
    CXXFLAGS="${OLEVEL} ${BFLAG}"
./configure --prefix=${PRODUCT_INSTALL} \
    --with-occ=${CASROOT} \
    --with-tcl=${TCLHOME}/lib \
    --with-tk=${TCLHOME}/lib \
    --with-tclinclude=${TCLHOME}/include \
    CXXFLAGS="${OLEVEL} ${BFLAG} -std=c++11 -std=c++0x" #-std=gnu++11" #-std=c++11 -std=c++0x"
    #--with-togl=${TCLHOME} \
    #LDFLAGS="-L${TCLHOME}/lib" \
    #CPPFLAGS="-I${TCLHOME}/include" \
    
if [ $? -ne 0 ]
then
    echo "error on configure"
    exit 1
fi

sed -i -e "s/\/inc -D_OCC64/\/include\/opencascade -D_OCC64/g" ${PRODUCT_BUILD}/libsrc/occ/Makefile
sed -i -e "s/\/inc -D_OCC64/\/include\/opencascade -D_OCC64/g" ${PRODUCT_BUILD}/libsrc/visualization/Makefile


echo
echo "*** compile"
make
if [ $? -ne 0 ]
then
    echo "error on make"
    exit 2
fi

echo
echo "*** install"
make install
if [ $? -ne 0 ]
then
    echo "error on make install"
    exit 3
fi

echo
echo "*** copy headers"
for directory in general gprim linalg meshing ; do
    cp -vf ${PRODUCT_BUILD}/libsrc/${directory}/*.hpp ${PRODUCT_INSTALL}/include
done
cp -vf ${PRODUCT_BUILD}/libsrc/include/mystdlib.h ${PRODUCT_BUILD}/libsrc/include/mydefs.hpp ${PRODUCT_INSTALL}/include
cp -vf ${PRODUCT_BUILD}/libsrc/occ/occ*.hpp ${PRODUCT_INSTALL}/include

if [ -f ${PRODUCT_BUILD}/config.h ] ; then
    cp -f ${PRODUCT_BUILD}/config.h ${PRODUCT_BUILD}/libsrc/occ/occmeshsurf.hpp ${PRODUCT_INSTALL}/include
fi

echo
echo "########## END"
