#!/bin/bash

echo "##########################################################################"
echo "packagespy" $VERSION
echo "##########################################################################"

# nothing to be done here, simply copy sources to installation directory
if [ ! -d $PRODUCT_INSTALL ]; then
    mkdir -p $PRODUCT_INSTALL
fi
cp -rf $SOURCE_DIR/packagespy $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR: could not copy to $PRODUCT_INSTALL"
    exit 1
fi
cd $PRODUCT_INSTALL/
echo $PRODUCT_INSTALL
ls -ltr
# ensure that we are using our python
PYTHON=${PYTHONBIN##*/}
echo "INFO: list of files which will be patched..."
for f in $(grep -rl '#!/usr/bin/env python' . ); do
    echo INFO: patching file $f
    sed -i "s%#\!/usr/bin/env python%#\!/usr/bin/env ${PYTHON}%g" $f
    if [ $? -ne 0 ]; then
        echo "ERROR: could not patch file: $f"
        exit 2
    fi
done

echo
echo "########## END"
