
#!/bin/bash

echo "##########################################################################"
echo "mpi4py" $VERSION
echo "##########################################################################"

fix_lib_path() {
    mkdir -p $PRODUCT_INSTALL/lib/python$PYTHON_VERSION
    # ensure that lib is used
    if [ -d "$PRODUCT_INSTALL/local" ]; then
        cp -r $PRODUCT_INSTALL/local/* $PRODUCT_INSTALL/
        rm -rf $PRODUCT_INSTALL/local
    fi

    if [ -d "$PRODUCT_INSTALL/lib64" ]; then
        echo "WARNING: renaming lib64 directory to lib"
        mv $PRODUCT_INSTALL/lib64/* $PRODUCT_INSTALL/lib/
        rm -rf $PRODUCT_INSTALL/lib64
    elif [ -d "$PRODUCT_INSTALL/local/lib64" ]; then
        echo "WARNING: renaming local/lib64 directory to lib"
        mv $PRODUCT_INSTALL/local/lib64/* $PRODUCT_INSTALL/lib
        rm -rf $PRODUCT_INSTALL/local
    elif [ -d $PRODUCT_INSTALL/lib ]; then
        :
    else
        echo "WARNING: unhandled case! Please ensure that script is consistent!"
    fi

    if [ -d ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ]; then
        mv ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/dist-packages ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
    fi
}

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo  "*** build in SOURCE directory"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_CACHE_DIR=${BUILD_DIR}/cache/pip

case $LINUX_DISTRIBUTION in
    CO10)
        echo "INFO: $PYTHONBIN -m venv $BUILD_DIR/${PRODUCT_NAME}_venv --system-site-packages"
        ${PYTHONBIN} -m venv "$BUILD_DIR/${PRODUCT_NAME}_venv" --system-site-packages
        if [ $? -ne 0 ]; then
            echo "ERROR: fail to create a venv"
            exit 1
        fi
        VENV_OPTIONS+=" "
        ;;
    *)
        echo "INFO: $PYTHONBIN -m venv $BUILD_DIR/${PRODUCT_NAME}_venv"
        ${PYTHONBIN} -m venv "$BUILD_DIR/${PRODUCT_NAME}_venv"
        if [ $? -ne 0 ]; then
            echo "ERROR: fail to create a venv"
            exit 1
        fi
        ;;
esac

# Set venv site-packages in priority
{
    echo "import sys"
    echo "import os"
    echo
    echo "# Get the path to this venv's site-packages"
    echo "venv_site = os.path.dirname(os.path.abspath(__file__))"
    echo
    echo "# If it exists in sys.path, pull it to the very front"
    echo "if venv_site in sys.path:"
    echo "    sys.path.remove(venv_site)"
    echo "sys.path.insert(0, venv_site)"
} > "$BUILD_DIR/${PRODUCT_NAME}_venv/lib/python$PYTHON_VERSION/site-packages/sitecustomize.py"

# install dependencies
echo "INFO: source ${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
. "${BUILD_DIR}/${PRODUCT_NAME}_venv/bin/activate"
if [ $? -ne 0 ]; then
    echo "ERROR: fail to create a venv"
    exit 2
fi

PYTHONBIN=$(which python)

$PYTHONBIN -m pip install "Cython>=3.0.0"

echo
echo "*** build and install with $PYTHONBIN"
$PYTHONBIN -m pip install $SOURCE_DIR \
	--no-binary :all: \
	--no-deps \
	--no-build-isolation \
	--ignore-installed \
	--prefix=$PRODUCT_INSTALL \
	-vvv
if [ $? -ne 0 ]; then
    echo "ERROR on build/install"
    exit 3
fi

fix_lib_path

echo
echo "########## END"
