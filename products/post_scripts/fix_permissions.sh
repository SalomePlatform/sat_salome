#!/bin/bash

echo "changing permissions..."
cd $PRODUCT_INSTALL
find . -type d | xargs chmod ugo+rx
find . -name \*.py | xargs chmod ugo+r
find . -type f -perm 640 | xargs chmod ugo+r
find . -type d -perm 700 | xargs chmod ugo+rx
find . -type f -perm 700 | xargs chmod ugo+r
find . -type f -perm 750 | xargs chmod uo+rx
