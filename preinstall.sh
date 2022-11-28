#!/bin/sh

echo "Create directories..."
mkdir -p src/asterisk src/dahdi src/libpri

echo "untar libpri..."
tar -zxf libpri-current.tar.gz -C src/libpri --strip-components=1
echo "Done!"
echo "untar dahdi..."
tar -zxf dahdi-linux-complete-current.tar.gz -C src/dahdi --strip-components=1
echo "Done!"
echo "untar asterisk..."
tar -zxf asterisk-18-current.tar.gz -C src/asterisk --strip-components=1

echo "All done!"