#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "TTK" $VERSION
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi
CMAKE_OPTIONS+=" -DTTK_BUILD_PARAVIEW_PLUGINS=ON"
CMAKE_OPTIONS+=" -DTTK_INSTALL_PLUGIN_DIR=${ParaView_DIR}/plugins"
CMAKE_OPTIONS+=" -Dembree_DIR:PATH=${EMBREE_ROOT_DIR}/lib/cmake/embree-${EMBREE_VERSION}"

# Embree CMake defines EMBREE_INCLUDE_DIRS but TTK uses EMBREE_INCUDE_DIR which is undefined.
CMAKE_OPTIONS+=" -DEMBREE_INCLUDE_DIR=${EMBREE_ROOT_DIR}/include"

if [ -n "$BOOST_ROOT_DIR" ] && [ "${SAT_boost_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DBoost_DIR:PATH=${Boost_DIR}"
    CMAKE_OPTIONS+=" -DBoost_INCLUDE_DIR:PATH=${BOOST_ROOT_DIR}/include"
fi

if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${SAT_libxml2_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
    CMAKE_OPTIONS+=" -Dpkgcfg_lib_PC_LIBXML_xml2=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
fi

if [ -n "$FREETYPE_ROOT_DIR" ] && [ "${SAT_freetype_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DFREETYPE_ROOT_DIR:PATH=${FREETYPE_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DFREETYPE_INCLUDE_DIRS:STRING=${FREETYPE_ROOT_DIR}/include/freetype2"
    CMAKE_OPTIONS+=" -DFREETYPE_LIBRARY:STRING=${FREETYPE_ROOT_DIR}/lib/libfreetype.so"
    CMAKE_OPTIONS+=" -Dpkgcfg_lib_PKG_FONTCONFIG_free:STRING=${FREETYPE_ROOT_DIR}/lib/libfreetype.so"
fi

if [ -n "$QT5_ROOT_DIR" ] && [ "${SAT_qt_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -Dqt_xmlpatterns_executable:PATH=${QT5_ROOT_DIR}/bin/xmlpatterns"
fi

# CPU optimization leads to non portable TTK  see bos #43158
CMAKE_OPTIONS+=" -DTTK_ENABLE_CPU_OPTIMIZATION=OFF"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

case $LINUX_DISTRIBUTION in
    DB09|DB10)
        # A.Geay (Sous debian10 sur nos VM de prod, on a pas mal de nos tests qui plantent avec des SIGILL)
        # D.Hoang: application à Debian 9
        CMAKE_OPTIONS+=" -DTTK_ENABLE_EIGEN=ON"
        ;;
    *)
        # bos #32890 : conflict at runtime between PlaneGCS and TTK which uses Eigen as well
        #              FIXME
        CMAKE_OPTIONS+=" -DTTK_ENABLE_EIGEN=OFF"
        ;;
esac

echo
echo "*** cmake" $CMAKE_OPTIONS
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd  $BUILD_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

if [ $LINUX_DISTRIBUTION == DB09 ]; then
    echo "WARNING: reset MAKE_OPTIONS"
    MAKE_OPTIONS=
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

echo
echo "########## END"
