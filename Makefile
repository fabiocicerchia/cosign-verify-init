IMAGE     ?= fabiocicerchia/cosign-verify-init
VERSION   ?= 2.5.3
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: setup build lint test push release

setup: ## Enable git hooks (gitleaks secret scan on commit)
	git config core.hooksPath .githooks
	@command -v pre-commit >/dev/null 2>&1 && pre-commit install || true

build:
	docker build --build-arg COSIGN_VERSION=$(VERSION) -t $(IMAGE):$(VERSION) .

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile
	shellcheck verify-images test.sh

test: build
	./test.sh $(IMAGE):$(VERSION)

push: build
	docker push $(IMAGE):$(VERSION)

release:
	docker buildx build --platform $(PLATFORMS) \
		--build-arg COSIGN_VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest --push .
