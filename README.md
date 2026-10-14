<img src="https://mons.cc/assets/mons-logo.svg" alt="Mons logo" width="128" height="128">

# Mons CLI

**Your terminal. Agent ready.**

This repository distributes the native Mons CLI and documentation for its
local user-level Host service. It does not distribute the mobile app or Relay
service, and it does not contain product, website or installation source.

**Status: in development.** [Mons CLI 0.5.29 development preview](https://github.com/venjiang/mons.cc/releases/tag/cli-v0.5.29)
provides native Host ZIPs for macOS and Linux. The macOS preview is ad-hoc signed,
not Developer ID signed or notarized, and Gatekeeper may block it. See the
[preview installation guide](docs/installation.md#development-preview-downloads).
The [curl installer](docs/installation.md#default-curl-from-github) downloads
the compiled CLI from GitHub, verifies the privately maintained platform
installer, then installs the CLI and registers/starts the local Host service.
The [npm development preview](https://www.npmjs.com/package/@venjiang/mons)
is also available as `@venjiang/mons@0.5.29` with the `beta` tag. It uses the
same native binaries and local Host installer; macOS signing limits still apply.

## Install the CLI and Host service

```sh
curl -fsSL https://mons.cc/install.sh | sh
mons status
mons pair
```

Run as your normal user without `sudo`. The Host service is not the Relay
service; installation does not enable SSH or install Herdr/tmux. See the
installation guide for checksum verification, requirements and upgrade safety.

For developers with Node.js 20 or later:

```sh
npm install -g @venjiang/mons@beta
# Or explicitly install/upgrade the local Host service:
npx @venjiang/mons@beta install
```

Use a writable npm prefix without `sudo`; do not force replacement of an
existing CLI link. npm's initial `latest` tag currently also points to this
development preview, not a notarized macOS release.

## Start here

- [Website](https://mons.cc)
- [Installation](docs/installation.md) — preview ZIPs, GitHub-backed curl and npm/npx.
- [Getting started](docs/getting-started.md) — connections, pairing and sessions.
- [Troubleshooting](docs/troubleshooting.md) — connection problems, logs and diagnostics.
- [Report a bug or request a feature](https://github.com/venjiang/mons.cc/issues/new/choose)
- [Security reports](SECURITY.md)

CLI packages target macOS Apple Silicon/Intel and Linux x86_64/arm64. Mobile app
and Relay downloads, installers and deployment flows are outside this repository.

## This repository

This is the public CLI-distribution, user-documentation and feedback repository.
Compiled CLI packages are
attached to [GitHub Releases](https://github.com/venjiang/mons.cc/releases)
rather than committed as large binary files.

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
