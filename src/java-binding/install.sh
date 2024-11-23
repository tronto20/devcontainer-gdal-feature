#!/bin/sh

set -e

echo "Install GDAL."

GDALVERSION=${GDALVERSION:-3.9.1}
CPU=${CPU:-4}
echo "The provided gdal version is: $GDALVERSION."
echo "Build Multi CPU: $CPU"

apt-get update
apt-get install -y build-essential wget cmake libtiff-dev libgeotiff-dev libproj-dev python3-dev python3-pip libxml2-dev libgeos-dev libjson-c-dev swig liblerc-dev ant proj-bin python3-numpy

mkdir /tmpbuild

# ref : https://gdal.org/development/building_from_source.html
wget -O /tmpbuild/gdal.tar.gz https://download.osgeo.org/gdal/${GDALVERSION}/gdal-${GDALVERSION}.tar.gz
tar -xzvf /tmpbuild/gdal.tar.gz -C /tmpbuild/
cd /tmpbuild/gdal-${GDALVERSION}
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . -j ${CPU:-4}
cmake --build . --target install
ldconfig

#pip install /tmpbuild/gdal-${GDALVERSION}/build/swig/python
cp /tmpbuild/gdal-${GDALVERSION}/build/swig/java/libgdalalljni.so /usr/local/lib/ && \
    cp /tmpbuild/gdal-${GDALVERSION}/build/swig/java/libgdalalljni.so /usr/lib/jni/

rm -r /tmp
