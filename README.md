<img src="https://mons.cc/assets/mons-logo.svg" alt="Mons logo" width="128" height="128">

# Mons CLI

**Your terminal. Agent ready.**

This repository distributes the native Mons CLI and documentation for its
local user-level Host service. It does not distribute the mobile app or Relay
service, and it does not contain product, website or installation source.

**Status: in development.** [Official CLI downloads](https://mons.cc/downloads/)
provide native Host ZIPs for macOS and Linux. The macOS preview is ad-hoc signed,
not Developer ID signed or notarized, and Gatekeeper may block it. See the
[preview installation guide](docs/installation.md#development-preview-downloads).
The [curl installer](docs/installation.md#default-curl-from-the-official-website) downloads
the compiled CLI from mons.cc, verifies the privately maintained platform
installer, then installs the CLI and registers/starts the local Host service.
npm distribution is retired. Previously published packages are not withdrawn,
but new installations and updates use the website. Existing npm users should
follow the [migration guide](docs/installation.md#migrate-an-existing-npm-installation).

## Install the CLI and Host service

```sh
curl -fsSL https://mons.cc/install.sh | sh
mons status
mons pair
```

Run as your normal user without `sudo`. The Host service is not the Relay
service; installation does not enable SSH or install Herdr/tmux. See the
installation guide for checksum verification, requirements and upgrade safety.

Node.js/npm are not required. Do not force replacement of an existing npm-owned
CLI link or delete Host state when changing installation methods.

## Start here

- [Website](https://mons.cc)
- [Installation](docs/installation.md) — preview ZIPs, website-backed curl and legacy npm migration.
- [Getting started](docs/getting-started.md) — connections, pairing and sessions.
- [Troubleshooting](docs/troubleshooting.md) — connection problems, logs and diagnostics.
- [Report a bug or request a feature](https://github.com/venjiang/mons.cc/issues/new/choose)
- [Security reports](SECURITY.md)

CLI packages target macOS Apple Silicon/Intel and Linux x86_64/arm64. Mobile app
and Relay downloads, installers and deployment flows are outside this repository.

## This repository

This is the public user-documentation, optional CLI-mirror and feedback repository.
The official website is the primary binary distribution and update source.
Historical mirrors remain in [GitHub Releases](https://github.com/venjiang/mons.cc/releases);
product source and large binary files are not committed to this repository.

Website source, installation logic, build tooling and deployment are maintained
in the private development repository. The website remains at https://mons.cc;
moving its source does not change the CLI download or installation addresses.

For `cli-v0.5.29`, the release tag is an independent README-only snapshot.
GitHub still displays automatic `Source code (zip)` and `Source code (tar.gz)`
links, but those archives contain documentation only. Download the named
`mons-0.5.29-*.zip` assets for the compiled CLI. Earlier repository history
has not been rewritten by the website-source migration.

The repository's [Apache-2.0 license](LICENSE) covers the documentation source
here. Product binaries have their own licensing and
third-party notices; they are not made open source by this repository.
