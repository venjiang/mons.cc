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
The npm package has not been published.

## Install the CLI and Host service

```sh
curl -fsSL https://mons.cc/install.sh | sh
mons status
mons pair
```

Run as your normal user without `sudo`. The Host service is not the Relay
service; installation does not enable SSH or install Herdr/tmux. See the
installation guide for checksum verification, requirements and upgrade safety.

## Start here

- [Website](https://mons.cc)
- [Installation](docs/installation.md) — preview ZIPs, GitHub-backed curl and the planned npm channel.
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

The repository's [Apache-2.0 license](LICENSE) covers the documentation source
here. Product binaries have their own licensing and
third-party notices; they are not made open source by this repository.
