#!/bin/sh

set -e

apt update

echo "Install OpenJDK."

JDK=${JDK:-21}
apt install -y build-essential openjdk-${JDK}-jdk

echo "Install GDAL."

GDALVERSION=${GDALVERSION:-3.9.1}
CPU=${CPU:-4}
echo "The provided gdal version is: $GDALVERSION."
echo "Build Multi CPU: $CPU"

apt install -y wget cmake libtiff-dev libgeotiff-dev libproj-dev python3-dev python3-pip libxml2-dev libgeos-dev libjson-c-dev swig liblerc-dev ant proj-bin python3-numpy

mkdir -p /tmp/gdal

# ref : https://gdal.org/development/building_from_source.html
wget -O /tmp/gdal/gdal.tar.gz https://download.osgeo.org/gdal/${GDALVERSION}/gdal-${GDALVERSION}.tar.gz
tar -xzvf /tmp/gdal/gdal.tar.gz -C /tmp/gdal/
cd /tmp/gdal/gdal-${GDALVERSION}
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . -j ${CPU:-4}
cmake --build . --target install
ldconfig

#pip install /tmp/gdal/gdal-${GDALVERSION}/build/swig/python
mkdir -p /usr/local/lib
mkdir -p /usr/lib/jni

cp /tmp/gdal/gdal-${GDALVERSION}/build/swig/java/libgdalalljni.so /usr/local/lib/
cp /tmp/gdal/gdal-${GDALVERSION}/build/swig/java/libgdalalljni.so /usr/lib/jni/

rm -r /tmp/gdal
