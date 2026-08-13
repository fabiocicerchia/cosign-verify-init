# CLAUDE.md

Guidance for Claude Code (and other AI agents) working in this repo.

## Project

cosign-verify-init is a shell-based init container (`verify-images`) that
verifies cosign image signatures before the main workload starts. It is
packaged as a minimal Docker image (distroless-friendly) and deployed as a
Kubernetes init container.

## Commands

```sh
make build   # build the Docker image locally
make lint    # hadolint the Dockerfile + shellcheck verify-images
make test    # run the negative-path test (unsigned image must fail)
make help    # Show this help
make setup   # Install the pre-commit hook
make push    # Push the tagged image
make release # Multi-arch buildx build and push (version + latest)
```

## Tooling

- `make setup` installs the pre-commit hook, and that is the whole of it.
  Don't add a `.githooks/` directory: `core.hooksPath` replaces `.git/hooks/`
  wholesale, so setting it silently stops every pre-commit hook from running.
- Hooks are pinned by commit SHA with the tag in a trailing comment. A tag can
  be moved, a SHA cannot.
- CI runs this same `.pre-commit-config.yaml` through `pre-commit/action`, so
  what passes locally is what gates the pull request.

## Conventions

- Keep `verify-images` POSIX-sh compatible; no bash-isms.
- Do not add runtime dependencies beyond cosign and shell builtins.
- Update `manifests/` and `examples/` when env-var interface changes.
- Don't hand-edit CHANGELOG.md or version.txt — release-please manages both.
- Use Conventional Commits (`feat:`/`fix:`/…); they drive the release version bump.
- Never commit secrets; CI runs gitleaks/trivy. Keep `.env` out of git.

## Guardrails

- Don't add unnecessary layers to the Dockerfile; keep the image minimal.
- Ask before changing the env-var interface (breaking change for users).
- Don't touch generated files or reports/ by hand.
