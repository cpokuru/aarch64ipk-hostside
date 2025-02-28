#!/bin/bash
# Improved script to create an IPK package compatible with stricter opkg implementations

APP_NAME="simple-app"
VERSION="1.0.0"
ARCH="aarch64"

# Clean up any previous attempt
rm -rf ipk control data debian-binary *.tar.gz ${APP_NAME}_${VERSION}_${ARCH}.ipk

# Create directory structure
mkdir -p ipk/data/usr/bin
mkdir -p ipk/control

# Copy binary to install directory
cp ${APP_NAME} ipk/data/usr/bin/

# Create control file
cat > ipk/control/control << EOC
Package: ${APP_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: User <user@example.com>
Description: Simple test application
Priority: optional
Section: utils
Source: simple-app
License: MIT
EOC

# Create conffiles (empty in this case)
touch ipk/control/conffiles

# Create preinst, postinst, prerm, postrm scripts (empty in this case)
for script in preinst postinst prerm postrm; do
  echo "#!/bin/sh" > ipk/control/${script}
  echo "exit 0" >> ipk/control/${script}
  chmod 755 ipk/control/${script}
done

# Create data.tar.gz (from the data directory)
cd ipk/data
tar -czf ../../data.tar.gz ./*
cd ../..

# Create control.tar.gz (from the control directory)
cd ipk/control
tar -czf ../../control.tar.gz ./*
cd ../..

# Create debian-binary file
echo "2.0" > debian-binary

# Create final IPK package
ar -r ${APP_NAME}_${VERSION}_${ARCH}.ipk debian-binary control.tar.gz data.tar.gz

# Clean up temporary files
rm -f debian-binary control.tar.gz data.tar.gz
rm -rf ipk

echo "Created ${APP_NAME}_${VERSION}_${ARCH}.ipk"
