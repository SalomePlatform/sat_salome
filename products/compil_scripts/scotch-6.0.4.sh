#!/bin/bash

echo "##########################################################################"
echo "ptscotch" $VERSION
echo "##########################################################################"

echo
echo "*** mkdir" $PRODUCT_INSTALL
mkdir -p $PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on mkdir"
    exit 1
fi
cp -ar $SOURCE_DIR/* ${BUILD_DIR}/
cd ${BUILD_DIR}/src

echo
echo "*** create Makefile"
if [ -n "$SAT_HPC" ]; then
    sed -e "s%CFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%CFLAGS\1=\2-fPIC -DPIC -DINTSIZE64 -DSCOTCH_PTHREAD -I${MPI_INCLUDE_DIR} \3%g" Make.inc/Makefile.inc.x86-64_pc_linux2 > Makefile.inc
else
    sed -e "s%CFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%CFLAGS\1=\2-fPIC -DPIC -DINTSIZE64 -DSCOTCH_PTHREAD \3%g" Make.inc/Makefile.inc.x86-64_pc_linux2 > Makefile.inc
fi
sed -e "s%LDFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%LDFLAGS\1=\2 \3 -lpthread%g" Makefile.inc > Makefile.in_new
mv Makefile.in_new Makefile.inc

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** Check if node is a virtual machine"
ISVM=$(hostnamectl status|grep -i chassis:|grep vm)
if [ ! -z "$ISVM" ]; then
    echo "*** oversubscribe..."
    sed -i 's/mpirun -n 4/mpirun -n 4 --oversubscribe/g' $BUILD_DIR/src/check/Makefile
else
    echo "*** hostnamectl says that $HOSTNAME is *NOT* a virtual machine"
fi

echo
echo "*** make ptcheck"
cd $BUILD_DIR/src
if [ -n "$SAT_HPC" ]; then
    make ptcheck
else
    make check
fi
if [ $? -ne 0 ]
then
    echo "ERROR on make check"
    exit 3
fi

echo
echo "*** Install"
cd $BUILD_DIR
for d in include lib bin; do
    cp -r $d $PRODUCT_INSTALL/$d
    if [ $? -ne 0 ]; then
	echo "FATAL: failed to deploy: $d"
	exit 3
    fi
done

echo
echo "########## END"
