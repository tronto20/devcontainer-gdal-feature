#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate gdal installed" gdalinfo --version | grep '3.10.0'

reportResults