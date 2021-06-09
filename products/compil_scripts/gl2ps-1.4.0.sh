#!/bin/bash
echo "##########################################################################"
echo "ispc" $VERSION
echo "##########################################################################"
if [[ $DIST_NAME == "DB" && $DIST_VERSION == "10" ]]
then
    # seems like SAT does not create BUILD_DIR ( ask for patch integration)
    mkdir -p $INSTALL_DIR && mkdir -p $BUILD_DIR && cd $BUILD_DIR
    # check wether a folder named
    FMT_EXISTS=0
    if [[ -e "$HOME/.texlive2018/texmf-var/web2c/pdftex/pdflatex.fmt" ]]
    then
        FMT_EXISTS=1
        mv $HOME/.texlive2018/texmf-var/web2c/pdftex/pdflatex.fmt $HOME/.texlive2018/texmf-var/web2c/pdftex/pdflatex.fmt.old
    fi

    CMAKE_OPTIONS=""
    CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
    CMAKE_OPTIONS+=" -DENABLE_PNG=ON"
    CMAKE_OPTIONS+=" -DENABLE_ZLIB=ON"
    CMAKE_OPTIONS+=" -DENABLE_GLUT=OFF"
    echo
    echo "*** cmake" ${CMAKE_OPTIONS}
    cmake ${CMAKE_OPTIONS} $SOURCE_DIR
    if [ $? -ne 0 ]
    then
        echo "ERROR on cmake"
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
    echo "*** make"
    make install
    if [ $? -ne 0 ]
    then
        echo "ERROR on make install"
        exit 3
    fi
    
    #
    if [[ $FMT_EXISTS -eq 1 ]]
       then
        mv $HOME/.texlive2018/texmf-var/web2c/pdftex/pdflatex.fmt.old $HOME/.texlive2018/texmf-var/web2c/pdftex/pdflatex.fmt
    fi   
    echo
    echo "########## END"
else
    echo "ERROR distribution: issue with: $DIST_NAME $DIST_VERSION - please fix gl2ps.sh script..."
    exit 1
fi
