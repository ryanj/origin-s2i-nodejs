# Include common Makefile code.
BASE_IMAGE_NAME = s2i-nodejs
ONBUILD_IMAGE_NAME = nodejs
NAMESPACE = ryanj
VERSIONS = 0.10.45 0.12.14 4.4.5 5.11.1 6.2.1

# Include common Makefile code.
include hack/common.mk
