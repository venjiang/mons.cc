# Mons CLI 0.5.29 — Binary Development Preview

This package contains a compiled native Mons CLI / Host, user documentation,
an SPDX SBOM and third-party license notices. No source files, installer scripts,
build scripts or project files are included.

This GitHub distribution is for the CLI and its local user-level Host service
only. It does not provide mobile app or Relay service downloads/installations.

Supported packages:

- macOS universal: Apple Silicon and Intel, macOS 13 or later.
- Linux x86_64: static musl executable.
- Linux aarch64: static musl executable.

## Install CLI and Host service with curl

```sh
curl -fsSL https://mons.cc/install.sh | sh
mons status
mons pair
```

The bootstrap downloads the precompiled CLI ZIP and checksums from this GitHub
release, then installs the CLI and registers/starts the local user-level Host
service. The installation logic is privately maintained and served by
`mons.cc`; its versioned platform installer is checked against the GitHub
`INSTALLER-SHA256SUMS` asset before execution. Installation scripts are not
published in this GitHub repository or inside the ZIPs.

Run as your normal user, without `sudo`. macOS uses a per-user LaunchAgent;
Linux requires an available `systemd --user` manager. The installer retains
the existing identity/pairing state and attempts rollback on a failed upgrade.
It does not enable SSH, systemd linger, or install the mobile app, Relay,
Herdr or tmux. `mons` is normally exposed at `~/.local/bin/mons`.

To validate downloads without installing or changing services:

```sh
curl -fsSL https://mons.cc/install.sh | sh -s -- --verify-only
```

To select this version, append `0.5.29` after `sh -s --`. Use this hosted entry,
not an obsolete bootstrap copied from the repository's old website tree.

## Manual download and verification

Download the platform ZIP and its matching `.sha256` file from
https://github.com/venjiang/mons.cc/releases/tag/cli-v0.5.29.

For example, download the macOS binary package directly from GitHub with curl:

```sh
curl -fLO https://github.com/venjiang/mons.cc/releases/download/cli-v0.5.29/mons-0.5.29-macos-universal.zip
curl -fLO https://github.com/venjiang/mons.cc/releases/download/cli-v0.5.29/mons-0.5.29-macos-universal.zip.sha256
```

For Linux, use the corresponding `linux-x86_64` or `linux-aarch64` filenames.

In the download directory, verify before extracting:

```sh
# macOS
shasum -a 256 -c mons-0.5.29-macos-universal.zip.sha256

# Linux x86_64 (replace linux-x86_64 with linux-aarch64 for arm64)
sha256sum -c mons-0.5.29-linux-x86_64.zip.sha256
```

Extract the ZIP. From its package directory:

```sh
./mons --version
./mons --help
```

The version is `mons 0.5.29 protocol 1`. Extraction does not install, update or
restart an existing Host service. Do not overwrite an existing managed CLI
link or running service binary to try this preview.

## Foreground Host

If no Mons Host is already running for your user:

```sh
./mons serve
```

Keep that terminal open. In another terminal, use this package's `./mons status`
and `./mons pair`. Run as your normal user, without `sudo`; only one Host should
run per user. Host operation creates or uses that user's identity and pairing
state. Stop the foreground Host with Ctrl-C when finished.

SSH access, Herdr/tmux and the mobile app are separate setups. Mons does not
enable Remote Login, change SSH settings or install a multiplexer automatically.
There is no installer script inside this binary-only ZIP. Use the hosted curl
entry above to install the CLI and background service.

## macOS signing

The macOS executable has an ad-hoc signature, not Developer ID signing or Apple
notarization. Gatekeeper may block downloaded copies. SHA-256 verifies integrity,
not developer identity or Apple approval. This preview does not disable system
security protections.

## Contents and licensing

`mons` is the compiled executable. `SBOM.spdx.json` binds its SHA-256 and platform
inventory; `THIRD_PARTY_NOTICES.txt` and `licenses/` contain dependency notices.
Retained experimental ICE license texts do not mean ICE is linked: this binary
uses the default ICE-disabled profile. Product source is not supplied by this
package or by the public repository's documentation archives.
