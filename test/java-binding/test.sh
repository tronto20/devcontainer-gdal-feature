#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate gdal installed" gdalinfo --version | grep 'GDAL'

reportResults