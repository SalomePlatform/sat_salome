#!/bin/bash

echo "##########################################################################"
echo "netgen" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

cp -r $SOURCE_DIR/* .

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $BUILD_DIR -type f -exec chmod u+rwx {} \;
fi

echo
echo "*** manual call of the aclocal, libtoolize, autoconf and automake in order to re-generate configure script and Makefiles"
aclocal -I m4 
if [ $? -ne 0 ]; then
    echo "error on manual call to aclocal"
    exit 1
fi

libtoolize --force --copy --automake
if [ $? -ne 0 ]; then
    echo "error on manual call to libtoolize"
    exit 1
fi

autoconf
if [ $? -ne 0 ]; then
    echo "error on manual call to autoconf"
    exit 1
fi

automake --copy --gnu --add-missing
if [ $? -ne 0 ]; then
    echo "error on manual call to automake"
    exit 1
fi

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
OLEVEL="-O2"

if [ "${TCLHOME}" != "/usr" ]; then
    TCL_TK_OPTIONS="--with-tcl=${TCLHOME}/lib --with-tk=${TCLHOME}/lib --with-tclinclude=${TCLHOME}/include"
fi

CONFIGURE_FLAGS="-std=c++0x"
if [ "$LINUX_DISTRIBUTION" == "FD42" ]; then
    CONFIGURE_FLAGS+=" -fpermissive"
fi   
echo ./configure --prefix=${PRODUCT_INSTALL} \
     --with-occ=${CASROOT} \
     --disable-openmp \
     ${TCL_TK_OPTIONS} \
     CXXFLAGS="-I${CASROOT}/include/opencascade ${OLEVEL} ${BFLAG} ${CONFIGURE_FLAGS}"

./configure --prefix=${PRODUCT_INSTALL} \
            --with-occ=${CASROOT} \
            --disable-openmp \
            ${TCL_TK_OPTIONS} \
            CXXFLAGS="-I${CASROOT}/include/opencascade ${OLEVEL} ${BFLAG} ${CONFIGURE_FLAGS}"

if [ $? -ne 0 ]; then
    echo "error on configure"
    exit 1
fi

echo
echo "*** make ${MAKE_OPTIONS}"
make  ${MAKE_OPTIONS}
if [ $? -ne 0 ]; then
    echo "error on make"
    exit 2
fi

echo
echo "*** install"
make install
if [ $? -ne 0 ]; then
    echo "error on make install"
    exit 3
fi

echo
echo "*** copy headers"
for directory in general gprim linalg meshing ; do
    cp -vf ${PRODUCT_BUILD}/libsrc/${directory}/*.h* ${PRODUCT_INSTALL}/include
done
cp -vf ${PRODUCT_BUILD}/libsrc/include/mystdlib.h ${PRODUCT_BUILD}/libsrc/include/mydefs.hpp ${PRODUCT_INSTALL}/include
cp -vf ${PRODUCT_BUILD}/libsrc/occ/occgeom.hpp ${PRODUCT_BUILD}/libsrc/occ/occmeshsurf.hpp ${PRODUCT_INSTALL}/include
cp -vf ${PRODUCT_BUILD}/libsrc/stlgeom/*.hpp ${PRODUCT_INSTALL}/include

echo
echo "########## END"
