IMAGE     ?= fabiocicerchia/cosign-verify-init
VERSION   ?= 2.5.3
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: setup build lint test push release help

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

setup: ## Install the pre-commit hook
	pre-commit install

build: ## Build the image locally
	docker build --build-arg COSIGN_VERSION=$(VERSION) -t $(IMAGE):$(VERSION) .

lint: ## Lint the Dockerfile and shell scripts
	docker run --rm -i hadolint/hadolint < Dockerfile
	shellcheck verify-images test.sh

test: build ## Build, then run the smoke tests
	./test.sh $(IMAGE):$(VERSION)

push: build ## Push the tagged image
	docker push $(IMAGE):$(VERSION)

release: ## Multi-arch buildx build and push (version + latest)
	docker buildx build --platform $(PLATFORMS) \
		--build-arg COSIGN_VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest --push .
