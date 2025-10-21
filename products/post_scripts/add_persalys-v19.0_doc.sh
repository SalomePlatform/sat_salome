#!/bin/bash

ARCHIVEFTP="ftp.cea.fr/pub/salome/prerequisites"

if [[ "$DIST_NAME$DIST_VERSION" == "DB11" ]]; then
   cd ${PRODUCT_INSTALL}/share
   curl -OL $ARCHIVEFTP/persalys_v19.0-x86_64-deb12-doc.tar.gz
   tar zxf persalys_v19.0-x86_64-deb12-doc.tar.gz
   rm -f persalys_v19.0-x86_64-deb12-doc.tar.gz
fi
