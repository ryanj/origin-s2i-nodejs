# Include common Makefile code.
BASE_IMAGE_NAME=s2i-nodejs
ONBUILD_IMAGE_NAME=nodejs
NAMESPACE=ryanj
VERSIONS = 0.10.46 0.12.15 4.4.7 5.12.0 6.3.0

# Include common Makefile code.
include hack/common.mk
