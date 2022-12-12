#!/bin/bash

echo "changing permissions..."
cd $PRODUCT_INSTALL
find . -type d | xargs -r chmod go+rx
find . -name \*.py | xargs -r chmod go+r
find . -type f -perm 640 | xargs -r chmod go+r
find . -type d -perm 700 | xargs -r chmod go+rx
find . -type f -perm 700 | xargs -r chmod go+r
find . -type f -perm 750 | xargs -r chmod go+rx
