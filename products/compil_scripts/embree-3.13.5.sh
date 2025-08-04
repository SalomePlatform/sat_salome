#!/bin/bash                                                                                                                                                                              
echo "##########################################################################"
echo "$PRODUCT_NAME $VERSION"
echo "##########################################################################"

mkdir -p $PRODUCT_INSTALL

directories=("bin" "lib" "include" "share")
for dir in "${directories[@]}"
do
    if [ -d "$SOURCE_DIR/$dir" ]; then
	 echo "INFO: copying $dir ..."
        cp -r $SOURCE_DIR/$dir $PRODUCT_INSTALL/$dir || { echo "FATAL: copying $dir failed"; exit 1; }
    else
        echo "WARNING: Directory $dir not found"
    fi
done

echo
echo "########## END"
