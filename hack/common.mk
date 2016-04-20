SKIP_SQUASH?=0

build = hack/build.sh

ifeq ($(TARGET),fedora)
	OS := fedora
else
	OS := centos7
endif

script_env = \
	SKIP_SQUASH="$(SKIP_SQUASH)"                      \
	VERSIONS="$(VERSIONS)"                            \
	OS="$(OS)"                                        \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: test
test:
	$(script_env) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true $(build)
