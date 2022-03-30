#!/bin/bash

echo "##########################################################################"
echo "scotch" $VERSION
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
    sed -e "s%CFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%CFLAGS\1=\2-fPIC \3%g" Make.inc/Makefile.inc.x86-64_pc_linux2 > Makefile.inc
fi
sed -e "s%LDFLAGS\([[:space:]]*\)=\([[:space:]]*\)\(.*\)%LDFLAGS\1=\2 \3 -lpthread%g" Makefile.inc > Makefile.in_new
mv Makefile.in_new Makefile.inc

echo
if [ -n "$SAT_HPC" ]; then
    SCOTCH_TARGET=ptscotch
else
    SCOTCH_TARGET=scotch
fi

echo "*** make" $MAKE_OPTIONS $SCOTCH_TARGET
make $MAKE_OPTIONS $SCOTCH_TARGET
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

# TODO: Open ARTIFACT
DO_CHECK=0
# DO_CHECK=1
# LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
# case $LINUX_DISTRIBUTION in
#     CO*|FD*)
# 	DO_CHECK=0
# 	;;
# esac

if [ $DO_CHECK -eq 1 ]; then
    echo
    echo "*** Check if node is a virtual machine"
    ISVM=$(hostnamectl status|grep -i chassis:|grep vm)
    if [ ! -z "$ISVM" ]; then
	echo "*** oversubscribe..."
	sed -i 's/mpirun -n 4/mpirun -n 4 --oversubscribe/g' $BUILD_DIR/src/check/Makefile
    else
	echo "*** hostnamectl says that $HOSTNAME is *NOT* a virtual machine"
    fi
    
    cd $BUILD_DIR/src
    if [ -n "$SAT_HPC" ]; then
	echo
	echo "*** make ptcheck"
	make ptcheck
    else
	echo
	echo "*** make check"
	make check
    fi
    if [ $? -ne 0 ]
    then
	echo "ERROR on make check"
	exit 3
    fi
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
