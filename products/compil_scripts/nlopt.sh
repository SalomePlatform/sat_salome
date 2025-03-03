#!/bin/bash

echo "##########################################################################"
echo "nlopt" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

#
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

# If Docker rootless, ensure that user can read them
if [ -f /.dockerenv ]; then
    find $SOURCE_DIR -type f -exec chmod u+rwx {} \;
fi

if version_ge $VERSION "2.4.2"; then
    $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --enable-shared --with-python PYTHON=$(which python3) PYTHON_CONFIG=$(which python3-config) CFLAGS='-m64 -fPIC' CPPFLAGS='-m64 -fPIC'
else
    $SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL --enable-shared --without-octave
fi
echo   "*** configure --prefix=$PRODUCT_INSTALL $CONFIGURE_ARGUMENTS"
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

case $LINUX_DISTRIBUTION in
	CO8*|CO9*)
		echo "WARNING: move files from lib64 to lib"
		mv $PRODUCT_INSTALL/lib64/python$PYTHON_VERSION/site-packages/* $PRODUCT_INSTALL/lib/python$PYTHON_VERSION/site-packages/
		rm -rf  $PRODUCT_INSTALL/lib64/
		;;
	*)
		;;
esac

echo
echo "########## END"

