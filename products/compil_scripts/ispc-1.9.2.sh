#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "ispc" $VERSION
echo "##########################################################################"

if [ -f "$SOURCE_DIR/bin/ispc" ]
then
    echo "INFO: about to copy the ispc binary utility to the installation folder: $PRODUCT_INSTALL/bin"
    mkdir -p $PRODUCT_INSTALL/bin
    cp  $SOURCE_DIR/bin/ispc $PRODUCT_INSTALL/bin
    chmod +x $PRODUCT_INSTALL/bin/ispc
else
    echo "INFO: compiling ispc..."
    cd $SOURCE_DIR
    TARGET_MAKE=gcc
    # issue with the current version of CLANG libraries
    if [[ $DIST_NAME == "UB" && $DIST_VERSION == "18.04" ]]
    then
	TARGET_MAKE=clang
    fi
    
    # CentOS 6
    if [[ $DIST_NAME == "CO" && $DIST_VERSION == "6" ]]
    then
	TARGET_MAKE=clang
    fi
    
    echo "*** make" $MAKE_OPTIONS $TARGET_MAKE
    make $MAKE_OPTIONS $TARGET_MAKE
    if [ $? -ne 0 ]
    then
	echo "ERROR on make"
	exit 2
    fi
    
    echo "INFO: about to copy the ispc binary utility to the installation folder: $PRODUCT_INSTALL/bin"
    mkdir -p $PRODUCT_INSTALL/bin
    cp $SOURCE_DIR/ispc $PRODUCT_INSTALL/bin
    chmod +x $PRODUCT_INSTALL/bin/ispc
fi

echo
echo "########## END"
