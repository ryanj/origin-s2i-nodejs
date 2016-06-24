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
	NAMESPACE="$(NAMESPACE)"                          \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	ONBUILD_IMAGE_NAME="$(ONBUILD_IMAGE_NAME)"        \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: all
all:
	make rebuild && make test && make build && make onbuild && make tags && make publish

.PHONY: onbuild
onbuild:
	$(script_env) ONBUILD=true $(build)

.PHONY: tags
tags:
	$(script_env) npm run tag

.PHONY: publish
publish:
	$(script_env) npm run pub

.PHONY: rebuild
rebuild:
	$(script_env) npm run rebuild

.PHONY: test
test:
	$(script_env) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true $(build)

.PHONY: clean
clean:
	npm run clean
