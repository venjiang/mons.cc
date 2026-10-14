# Installation

## Availability

Mons is in development. [Mons CLI 0.5.29 development preview](https://github.com/venjiang/mons.cc/releases/tag/cli-v0.5.29)
contains native Host ZIPs for macOS and Linux. ZIPs and their checksum files are
downloaded from GitHub Releases, including through the curl installer below.
The npm preview `@venjiang/mons@0.5.29` is published with the `beta` tag.

This repository provides CLI and local Host service installation only. It does
not provide mobile app or Relay downloads/installations.

## Development preview downloads

Download the ZIP and its matching `.sha256` file from the preview release:

| Platform | Archive |
| --- | --- |
| macOS 13+ Apple Silicon / Intel | `mons-0.5.29-macos-universal.zip` |
| Linux x86_64 | `mons-0.5.29-linux-x86_64.zip` |
| Linux arm64 | `mons-0.5.29-linux-aarch64.zip` |

The macOS executable is **ad-hoc signed, not Developer ID signed or Apple
notarized**. Gatekeeper may block a downloaded copy. A checksum verifies
integrity, not developer identity or Apple approval; this preview does not
disable or bypass system security protections.

In the download directory, verify the selected archive before extracting it:

```sh
# macOS
shasum -a 256 -c mons-0.5.29-macos-universal.zip.sha256

# Linux x86_64 (use linux-aarch64 instead for arm64)
sha256sum -c mons-0.5.29-linux-x86_64.zip.sha256
```

Each ZIP contains `mons`, `README.md`, `SBOM.spdx.json`, dependency notices and
license texts, but no installation scripts. Read its README and use the hosted
curl entry below to install the CLI and user-level Host service. For manual
verification, run the compiled executable from the extracted directory:

```sh
./mons --version
./mons --help
```

GitHub's automatic `Source code` ZIP and tar.gz for `cli-v0.5.29` contain only
the release's README snapshot, not the CLI binary or website source. They are
not installation packages; use the named platform assets in the table above.

Installation creates or updates a per-user Host service. It does not install
the mobile app or configure SSH access or Herdr/tmux. Container CLI smoke tests
do not replace real Linux systemd installation or complete pairing and
upgrade/rollback acceptance.

## Host requirements

| Platform | Host installation |
| --- | --- |
| macOS | macOS 13+ on Apple Silicon or Intel; run as the logged-in user without sudo |
| Linux | x86_64 or arm64; a non-root user and an available systemd user manager |
| Windows | Not supported by the current Host packages |

The Host installer does not enable SSH access, create user accounts or install
Herdr/tmux. Configure those separately if you need them. For macOS terminal
access, enable Remote Login for the intended user. Linux requires an SSH server
and credentials accepted by that server.

The curl route requires download, ZIP and integrity tools. On macOS these
include curl, shasum, unzip, codesign, lipo and plutil. On Linux they include
curl, sha256sum, unzip, jq, file and bash; service installation also needs flock,
timeout and stat. It does not enable systemd linger automatically.

## Default: curl from GitHub

Use the privately maintained bootstrap hosted by Mons:

```sh
curl -fsSL https://mons.cc/install.sh | sh
```

To check a download without installing or changing the service:

```sh
curl -fsSL https://mons.cc/install.sh | sh -s -- --verify-only
```

To select a specific published Host version:

```sh
curl -fsSL https://mons.cc/install.sh | sh -s -- VERSION
```

Replace `VERSION` with the published `x.y.z` value, for example `0.5.29`.
Explicit versions use the `cli-vVERSION` release tag without a version-list
request. By default, the installer selects the highest numeric CLI version
among the latest 20 GitHub release records; published development previews are
included, while drafts and non-CLI tags are ignored. API failures stop before
installation; specify a version to avoid the list request.

The bootstrap downloads the compiled CLI ZIP, its SHA256 and
`INSTALLER-SHA256SUMS` from GitHub. It validates the archive/binary inventory and
the versioned private platform installer served by `mons.cc`, then installs the
CLI and registers/starts the local user-level Host service. Installer and website
source are maintained privately, not in this repository. macOS signature
integrity and architecture checks remain enabled; they do not establish
Developer ID or Apple notarization. App and Relay installation are not provided.

## Alternative: npm/npx

This route requires Node.js 20 or later and npm. The development preview is
published as `@venjiang/mons@0.5.29` with the `beta` tag. macOS is still ad-hoc
signed and unnotarized. npm's initial `latest` tag currently selects the same
preview; it does not establish Developer ID signing or Apple approval.

```sh
npm install -g @venjiang/mons@beta
mons status
mons pair
```

Use a writable npm global prefix as your normal user, without sudo. Keep
optional dependencies enabled: the matching native binary is in a platform
package. Global installation invokes the same service installer as curl.
Local project installation and npx cache downloads do not start the service.

To explicitly install or upgrade the Host using the package:

```sh
npx @venjiang/mons@beta install
```

If installation scripts were disabled with `--ignore-scripts`, run the npm
entry's `mons install` afterwards. The native ZIP CLI does not have that
package-specific command. No second binary download takes place at runtime.

## Commands and upgrades

The native installer normally exposes `mons` at `~/.local/bin/mons`. Ensure
that directory is on your PATH. npm exposes its launcher through its global
bin directory. Check which command is selected:

```sh
command -v mons
mons --version
mons status
```

Use the same channel for routine upgrades. curl re-runs its verified installer;
npm can install an explicit published package version. Both use the same Host
identity and pairing storage and attempt to restore the old service on failure.
They do not create separate Host services per installation channel.

If an existing ZIP CLI occupies the same path as npm's global bin, npm may
report `EEXIST` before installation scripts run. Use a separate writable npm
prefix rather than forcing replacement of an existing command. When npm owns
the shared CLI path, the Host installer leaves its launcher untouched.

`npm uninstall -g` removes the npm entry, not the independently installed Host
service or its pairing records. `mons unpair` revokes pairing; it is not a
service-uninstall command. Do not delete identity files to resolve an upgrade.

## Next

Continue with [Getting started](getting-started.md) or [Troubleshooting](troubleshooting.md).
