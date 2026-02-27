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

WHEELS=('typing_extensions-4.11.0-py3-none-any.whl'
        'meshio-5.3.5-py3-none-any.whl'
       )
for WHEEL in "${WHEELS[@]}"; do
    ${PYTHONBIN} -m pip install --cache-dir=$BUILD_DIR/cache/pip  $SOURCE_DIR/$WHEEL --no-deps --target=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages
    if [ $? -ne 0 ]; then
        echo "ERROR: could not install $WHEEL"
        exit 1
    fi
done

pyVersionMajor=python$($PYTHONBIN -c 'import sys; print(".".join(map(str, sys.version_info[0:1])))')
if [ $? -ne 0 ]; then
    echo ERROR: Failed to extract major Python version -  assuming Python version equal to 3...
    pyVersionMajor=python3
fi

echo INFO: Python version major: ${pyVersionMajor}
if [ -f $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/bin/meshio ]; then
    sed -i "s%#\!.*python[0-9]*%#\!/usr/bin/env ${pyVersionMajor}%#g" $PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/bin/meshio
else
    echo "FATAL: could not find meshio runner!"
    exit  1
fi

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

# bos #49114 - numpy2 issue see https://salsa.debian.org/science-team/python-meshio/-/blob/master/debian/patches/numpy2_PR1513.patch
NUMPY_MAJ_VERSION=$($PYTHONBIN -c "import numpy; print(numpy.__version__)" | cut -d'.' -f1)
echo ""
if [[ $NUMPY_MAJ_VERSION -eq 2 ]]; then
    echo "WARNING: numpy2 found. apply patch for dolfin"
    fPy=$PRODUCT_INSTALL/lib/python${PYTHON_VERSION}/site-packages/meshio/dolfin/_dolfin.py
    if [ -f $fPy ]; then
        line=$(grep -nA0 "ET.SubElement(mesh_function" $fPy| cut -d':' -f1)
        sed -i "${line}s/repr/str/" $fPy
    fi
fi

echo
echo "########## END"
