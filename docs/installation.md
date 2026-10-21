# Installation

## Availability

Mons is in development. [Mons CLI 0.5.30 development preview](https://mons.cc/downloads/)
contains native Host ZIPs for macOS and Linux. ZIPs and their checksum files are
downloaded from the official website, including through the curl installer below.

This repository provides CLI and local Host service installation only. It does
not provide mobile app or Relay downloads/installations.

## Development preview downloads

Download the ZIP and its matching `.sha256` file from [official downloads](https://mons.cc/downloads/):

| Platform | Archive |
| --- | --- |
| macOS 13+ Apple Silicon / Intel | `mons-0.5.30-macos-universal.zip` |
| Linux x86_64 | `mons-0.5.30-linux-x86_64.zip` |
| Linux arm64 | `mons-0.5.30-linux-aarch64.zip` |

The macOS executable is **ad-hoc signed, not Developer ID signed or Apple
notarized**. Gatekeeper may block a downloaded copy. A checksum verifies
integrity, not developer identity or Apple approval; this preview does not
disable or bypass system security protections.

In the download directory, verify the selected archive before extracting it:

```sh
# macOS
shasum -a 256 -c mons-0.5.30-macos-universal.zip.sha256

# Linux x86_64 (use linux-aarch64 instead for arm64)
sha256sum -c mons-0.5.30-linux-x86_64.zip.sha256
```

Each ZIP contains `mons`, `README.md`, `SBOM.spdx.json`, dependency notices and
license texts, but no installation scripts. Read its README and use the hosted
curl entry below to install the CLI and user-level Host service. For manual
verification, run the compiled executable from the extracted directory:

```sh
./mons --version
./mons -V
./mons --help
```

GitHub's automatic `Source code` ZIP and tar.gz for `cli-v0.5.29` contain only
the release's README snapshot, not the CLI binary or website source. They are
not installation packages; use the named platform assets in the table above.

Installation creates or updates a per-user Host service. It does not install
the mobile app or configure SSH access or an external Herdr/tmux. Container CLI smoke tests
do not replace real Linux systemd installation or complete pairing and
upgrade/rollback acceptance.

## Host requirements

| Platform | Host installation |
| --- | --- |
| macOS | macOS 13+ on Apple Silicon or Intel; run as the logged-in user without sudo |
| Linux | x86_64 or arm64; a non-root user and an available systemd user manager |
| Windows | Not supported by the current Host packages |

The Host installer does not enable SSH access, create user accounts or install
an external Herdr/tmux. Builds that carry bundled Herdr prepare a separate
private runtime; check the binary's help before using that capability. Configure
external multiplexers separately if needed. For macOS terminal
access, enable Remote Login for the intended user. Linux requires an SSH server
and credentials accepted by that server.

The curl route requires download, ZIP and integrity tools. On macOS these
include curl, shasum, unzip, codesign, lipo and plutil. On Linux they include
curl, sha256sum, unzip, jq, file and bash; service installation also needs flock,
timeout and stat. It does not enable systemd linger automatically.

## Default: curl from the official website

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

Replace `VERSION` with the published `x.y.z` value, for example `0.5.30`.
By default, the installer reads the current platform version from
`https://mons.cc/downloads/latest.json`. Explicit versions skip the manifest
request. No GitHub API, account or token is required; an invalid or unavailable
manifest stops before installation, without silently switching download sources.

The bootstrap downloads the compiled CLI ZIP, its SHA256 and
`INSTALLER-SHA256SUMS` from the official website. It validates the archive/binary inventory and
the versioned private platform installer served by `mons.cc`, then installs the
CLI and registers/starts the local user-level Host service. Installer and website
source are maintained privately, not in this repository. macOS signature
integrity and architecture checks remain enabled; they do not establish
Developer ID or Apple notarization. App and Relay installation are not provided.

## Commands and upgrades

The native installer normally exposes `mons` at `~/.local/bin/mons`. Ensure
that directory is on your PATH. Check which command is selected:

```sh
command -v mons
mons --version
mons -V
mons status
```

CLI 0.5.30 supports `mons --version` and `mons -V`; the old `mons version`
subcommand is removed. Check for updates without installing, or update explicitly:

```sh
mons update --check
mons update
```

Both commands read the official website's platform version. An identical or
newer installed version is not reinstalled or downgraded. Native updates use
the verified website installer. Older native releases without the update
command need one ordinary curl upgrade first.
Older Linux releases that already have `update` can also need a one-time curl
migration; see [Legacy Linux update fails on bundled Herdr](#legacy-linux-update-fails-on-bundled-herdr).

The installer preserves Host identity and pairing and attempts to restore the
old service on failure. It does not create another Host per installation method.
`mons unpair` revokes pairing; it is not a service-uninstall command. Do not
delete identity files to resolve an upgrade.

## Legacy Linux update fails on bundled Herdr

Older native Linux clients, including CLI 0.5.30, can reject a valid release
that bundles Herdr with this error:

```text
Host SBOM does not match downloaded binary/version
```

Those clients have `mons update`, but its package validation is embedded in
the installed executable and only recognizes the older dependency inventory.
Publishing a new ZIP cannot repair that embedded validation. The rejected
update does not install the new CLI or restart the Host.

**Use this recovery only after both the fixed website installer and a fixed
release are available for your Linux platform.** The compatibility fix is
planned for CLI 0.6.5; a source change or a new ZIP alone does not establish
that both are deployed. Until then, wait for the corrected installation entry
and release. Do not bypass SBOM, checksum or TLS checks.

Once both are available, first verify the published download without installing:

```sh
curl -fsSL https://mons.cc/install.sh | sh -s -- --verify-only
```

If verification succeeds, run the current website installer once as your normal
user, without sudo:

```sh
curl -fsSL https://mons.cc/install.sh | sh
```

Then check `command -v mons`, `mons --version` and `mons status`. The command
must select the standard native installation at `~/.local/bin/mons`.
After this one-time migration, the fixed CLI can use `mons update` for later
published releases. Installation may briefly restart the Host, but does not
require deleting identity, pairing, session state or Herdr directories.

If verification still reports an SBOM mismatch after the fixed entry and
release are confirmed available, stop and retain the exact error and versions
for a report. Do not force installation.

## Built-in terminal and session commands

Newer Host source builds include a private bundled Herdr terminal and
`mons session attach`, `mons session stop` and `mons session delete`. These
capabilities are separate from publishing a package. Check the actual binary
with `mons --help` and `mons session --help`; do not assume that the currently
published preview includes commands from a later source merge.

In a supporting build, `mons` in an interactive terminal or `mons open` selects
`default`; `mons session attach work` creates, starts or enters a named private
session. The original `mons open work` and `mons ls [--json]` remain supported.
No separate Herdr/tmux installation is needed for bundled sessions; existing
external installations remain independent. SSH access must still be enabled
separately.

**Stop terminates pane processes; delete permanently removes saved state.**
Delete requires an already stopped named session, refuses unknown status and
cannot delete `default`. There is no CLI detach command. Read the
[session lifecycle guide](getting-started.md#stop-or-permanently-delete-a-session)
before using either destructive operation. `mons update` only retrieves a
published version and cannot install unpublished session commands.

## Next

Continue with [Getting started](getting-started.md) or [Troubleshooting](troubleshooting.md).
