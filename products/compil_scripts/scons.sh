#!/bin/bash
#
echo "##########################################################################"
echo "Scons" $VERSION
echo "##########################################################################"
#
cd $SOURCE_DIR
#
echo
echo "*** setup.py"
python setup.py install --prefix=${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on setup"
    exit 3
fi
echo
echo "########## END"

