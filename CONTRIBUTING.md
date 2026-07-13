# Contributing

Thanks for taking the time to contribute to cosign-verify-init!

## Development setup

You need Docker (with buildx for multi-arch), `make` and `shellcheck`.

```sh
make build   # build the image locally
make lint    # hadolint + shellcheck
make test    # build + smoke test (./test.sh)
```

## Pull requests

1. Fork and create a topic branch.
1. Make your change, keeping the existing style; add or update tests.
1. Make sure `make lint` and `make test` pass locally.
1. Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`,
   `fix:`, `docs:`, …) — the changelog and version bump are generated from them,
   so don't edit `CHANGELOG.md` by hand.
1. Open a PR with a clear description of the problem and the solution.

## Releases

Releases are automated by [release-please](.github/workflows/release.yml); you
don't tag or edit the changelog manually.

1. Merge `feat:`/`fix:` PRs into `main` as normal — **no tag is created**.
1. release-please keeps an open **release PR** ("chore: release X.Y.Z"),
   recalculating the next version (`version.txt`) and changelog on every merge.
1. When you're ready to ship, **merge the release PR** — that (and only that)
   creates the `vX.Y.Z` tag, the GitHub Release, and pushes the image to GHCR.

## License

By contributing you agree that your contributions are licensed under the
Apache License 2.0 (see `LICENSE`).
