#!/bin/bash

echo "##########################################################################"
echo "lata" $VERSION
echo "##########################################################################"

# create the build directory
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
cd $BUILD_DIR
# copy everything from the source
cp -r $SOURCE_DIR/* .

# LATA source directory
LATA_SRC_DIR=$BUILD_DIR/src

# LATA binary directory
LATA_BIN_DIR=$BUILD_DIR/bin

# build folder
mkdir -p $BUILD_DIR/plugin_visit/build_paraview

# copy the patched CMake file... caution, the patch is provided with the archive
cp $BUILD_DIR/plugin_visit/CMakeLists.txt.para $BUILD_DIR/plugin_visit/build_paraview/CMakeLists.txt

cd $BUILD_DIR/plugin_visit/build_paraview

# add required symbolic links
ln -s $BUILD_DIR/plugin_visit/src/avtlataFileFormat.* .

for i in $LATA_SRC_DIR/commun_triou/*.cpp $LATA_SRC_DIR/triou_compat/*.cpp
do
    ln -s $i `basename $i .cpp`.C
done

for i in $LATA_SRC_DIR/commun_triou/*.h $LATA_SRC_DIR/triou_compat/*.h
do
    ln -s $i `basename $i`
done

# define the VISITLIBPATH variable
VISITLIBPATH=$BUILD_DIR/VisItLib

echo 
echo "INFO: running cmake -DVisItBridgePlugin_SOURCE_DIR=$BUILD_DIR/VisItLib"

cd $BUILD_DIR/build_paraview
cmake -DVisItBridgePlugin_SOURCE_DIR=$BUILD_DIR/VisItLib 
if [ $? -ne 0 ]
then
    echo "ERROR: failed to run command: cmake -DVisItBridgePlugin_SOURCE_DIR=$BUILD_DIR/VisItLib"
    exit 1
fi

echo
echo "INFO: fix vtkVisItReaderlataSM.xml"
sed '5a\     <Hints>\n        <ReaderFactory extensions="lata"\n            file_description="LATA Files">\n        </ReaderFactory>\n     </Hints> ' vtkVisItReaderlataSM.xml > tmp.txt
mv tmp.txt vtkVisItReaderlataSM.xml

# create a doc folder
mkdir -p doc

echo
echo "INFO: running command: make..."
make
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "INFO: copy the shared objects library to the installation folder"
mkdir -p ${PRODUCT_INSTALL}/lib
cp libVisItReaderlata.so ${PRODUCT_INSTALL}/lib

echo
echo "########## END"
