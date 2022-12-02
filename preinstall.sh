#!/bin/sh

echo "Create directories..."
mkdir -p src/asterisk src/dahdi src/libpri

echo "untar libpri..."
tar -zxf libpri-1.6.0.tar.gz -C src/libpri --strip-components=1
echo "Done!"
echo "untar dahdi..."
tar -zxf dahdi-linux-complete-current.tar.gz -C src/dahdi --strip-components=1
echo "Done!"
echo "untar asterisk..."
tar -zxf asterisk-20-current.tar.gz -C src/asterisk --strip-components=1

echo "All done!"