#!/bin/bash

echo "##########################################################################"
echo "mesa" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR
autoreconf -fi

cd $BUILD_DIR

echo

function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

if version_ge $VERSION "19"; then
    echo "*** configure --prefix=$PRODUCT_INSTALL --enable-opengl --disable-gles1 --disable-gles2 --disable-va --disable-xvmc --disable-vdpau --enable-shared-glapi --disable-texture-float --enable-llvm --disable-llvm-shared-libs --with-llvm-prefix=$LLVM_ROOT_DIR --with-gallium-drivers=swrast --disable-dri --with-dri-drivers= --disable-egl --with-platforms=x11 --disable-gbm --enable-glx=gallium-xlib --disable-osmesa --enable-gallium-osmesa --enable-autotools"
    $SOURCE_DIR/configure                 \
    --prefix=$PRODUCT_INSTALL             \
    --enable-opengl --disable-gles1 --disable-gles2 \
    --disable-va --disable-xvmc --disable-vdpau \
    --enable-shared-glapi \
    --disable-texture-float \
    --enable-llvm --disable-llvm-shared-libs \
    --with-llvm-prefix=$LLVM_ROOT_DIR                 \
    --with-gallium-drivers=swrast \
    --disable-dri --with-dri-drivers= \
    --disable-egl --with-platforms=x11 --disable-gbm \
    --enable-glx=gallium-xlib \
    --disable-osmesa --enable-gallium-osmesa \
    --enable-autotools
elif version_ge $VERSION "17"; then
    "*** configure --prefix=$PRODUCT_INSTALL --enable-opengl --disable-gles1 --disable-gles2 --disable-va --disable-xvmc --disable-vdpau --enable-shared-glapi --disable-texture-float --enable-gallium-llvm --enable-llvm-shared-libs --with-llvm-prefix=$LLVM_ROOT_DIR --with-gallium-drivers=swrast --disable-dri --with-dri-drivers= --disable-egl --with-platforms=x11 --disable-gbm --enable-glx=gallium-xlib --disable-osmesa --enable-gallium-osmesa"
    $SOURCE_DIR/configure                 \
    --prefix=$PRODUCT_INSTALL             \
    --enable-opengl --disable-gles1 --disable-gles2 \
    --disable-va --disable-xvmc --disable-vdpau \
    --enable-shared-glapi \
    --disable-texture-float \
    --enable-gallium-llvm --enable-llvm-shared-libs \
    --with-llvm-prefix=$LLVM_ROOT_DIR                 \
    --with-gallium-drivers=swrast \
    --disable-dri --with-dri-drivers= \
    --disable-egl --with-platforms=x11 --disable-gbm \
    --enable-glx=gallium-xlib \
    --disable-osmesa --enable-gallium-osmesa

else
    "*** configure --prefix=$PRODUCT_INSTALL CXXFLAGS=-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31 CFLAGS=-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31 --enable-opengl --disable-gles1 --disable-gles2 --disable-va --disable-xvmc --disable-vdpau --enable-shared-glapi --disable-texture-float --enable-gallium-llvm --enable-llvm-shared-libs --with-llvm-prefix=$LLVM_ROOT_DIR --with-gallium-drivers=swrast,swr --disable-dri --with-dri-drivers= --disable-egl --with-egl-platforms= --disable-gbm --enable-glx=gallium-xlib --disable-osmesa --enable-gallium-osmesa PYTHON2=${PYTHON_ROOT_DIR}/bin/python"
    $SOURCE_DIR/configure CXXFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" \
                          CFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" \
                          --prefix=$PRODUCT_INSTALL             \
                          --enable-opengl --disable-gles1 --disable-gles2   \
                          --disable-va --disable-xvmc --disable-vdpau       \
                          --enable-shared-glapi                             \
                          --disable-texture-float                           \
                          --enable-gallium-llvm --enable-llvm-shared-libs   \
                          --with-llvm-prefix=$LLVM_ROOT_DIR                 \
                          --with-gallium-drivers=swrast,swr                 \
                          --disable-dri --with-dri-drivers=                 \
                          --disable-egl --with-egl-platforms= --disable-gbm \
                          --enable-glx=gallium-xlib                         \
                          --disable-osmesa --enable-gallium-osmesa \
                          PYTHON2=${PYTHON_ROOT_DIR}/bin/python
fi
    
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make -j8 $MAKE_OPTIONS
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

