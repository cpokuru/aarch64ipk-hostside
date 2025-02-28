#!/bin/bash
# Script to create an IPK package without opkg-utils

APP_NAME="simple-app"
VERSION="1.0.0"
ARCH="aarch64"

# Create directory structure
mkdir -p ipk/usr/bin
mkdir -p ipk/CONTROL

# Copy binary to install directory
cp ${APP_NAME} ipk/usr/bin/

# Create control file
cat > ipk/CONTROL/control << EOC
Package: ${APP_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: User <user@example.com>
Description: Simple test application
Priority: optional
Section: utils
EOC

# Create data.tar.gz
cd ipk
tar -czf ../data.tar.gz ./usr
cd ..

# Create control.tar.gz
cd ipk
tar -czf ../control.tar.gz ./CONTROL
cd ..

# Create debian-binary file
echo "2.0" > debian-binary

# Create final IPK package
ar r ${APP_NAME}_${VERSION}_${ARCH}.ipk debian-binary control.tar.gz data.tar.gz

# Clean up temporary files
rm -f debian-binary control.tar.gz data.tar.gz
rm -rf ipk

echo "Created ${APP_NAME}_${VERSION}_${ARCH}.ipk"
