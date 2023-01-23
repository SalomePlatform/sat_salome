#!/bin/bash

echo "##########################################################################"
echo "packagespy" $VERSION
echo "##########################################################################"

# nothing to be done here, simply copy sources to installation directory
cp -rf $SOURCE_DIR/packagespy $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR: could not copy to $PRODUCT_INSTALL"
    exit 1
fi
cd $PRODUCT_INSTALL/
PYTHON=${PYTHONBIN##*/}
grep -rl '#!/usr/bin/env python' . |xargs sed -i "s%#\!/usr/bin/env python/#\!/usr/bin/env ${PYTHON}/g"

echo
echo "########## END"
