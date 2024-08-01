#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "meshio" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

echo "*** check installation"
mkdir -p ${PRODUCT_INSTALL}
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/cache/pip
cd $BUILD_DIR

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PATH=${PRODUCT_INSTALL}/bin:$PATH

WHEELS=('cached_property-1.5.2-py2.py3-none-any.whl'
        'meshio-4.3.13-py3-none-any.whl'
       )
for WHEEL in "${WHEELS[@]}"; do
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --prefix=$PRODUCT_INSTALL
    if [ $? -ne 0 ]; then
        echo "ERROR: could not install $WHEEL"
        exit 1
    fi
done

# bos #42618 - https://github.com/nschloe/meshio/issues/1484
fPy=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/meshio/gmsh/main.py
if [ -f $fPy ]; then
    sed -i 's/"gmsh": lambda f, m, \*\*kwargs: write(f, m, "4.1", \*\*kwargs)/"gmsh40": lambda f, m, \*\*kwargs: write(f, m, "4.0", \*\*kwargs)/g' $fPy
    if [ $? -ne 0 ]; then
        echo "FATAL: could not apply fixes to GMSH MeshIO driver"
        exit 1
    fi
else
    echo "FATAL: could not find GMSH MeshIO driver!"
    exit 1
fi

# spns #42665
fPy=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/meshio/ansys/_ansys.py
if [ -f $fPy ]; then
    statusCode=0
    # retrieve line number
    l=$(grep -nA0 "raise KeyError" $fPy|cut -d':' -f1)
    L=$(($l+2))
    sed -i 's/raise KeyError(/warn(/g' $fPy
    statusCode=$(($statusCode+$?))
    sed -i "${L}s/)/)\n                continue/g"  $fPy
    statusCode=$(($statusCode+$?))
    sed -i 's/(legal: {legal_keys})/(legal: {legal_keys}). Cell will be skipped!/g' $fPy
    statusCode=$(($statusCode+$?))
    if [ $statusCode -ne 0 ]; then
        echo "FATAL: could not apply fixes to ANSYS MeshIO driver"
        exit 1
    fi
else
    echo "FATAL: could not find ANSYS MeshIO driver!"
    exit 1
fi

echo
echo "########## END"
