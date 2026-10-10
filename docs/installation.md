# Installation

## Availability

Mons is in development. No public product release has been attached to this
repository yet, and the npm package is not published. Use only a build supplied
through the current development or beta process. The following commands
describe the public installation flow once releases are available.

The iPhone app is installed separately. Its App Store or TestFlight link will
be published when available; downloading a Host ZIP does not install the app.

## Host requirements

| Platform | Host installation |
| --- | --- |
| macOS | Apple Silicon or Intel; run as the logged-in user without sudo |
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

## Default: curl

After a public release is available:

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

Replace `VERSION` with the published `x.y.z` value. The bootstrap verifies the
archive checksum, required files and binary inventory before handing control
to the matching per-user installer. Public macOS packages also require the
release signing and architecture checks.

## Alternative: npm/npx

This route requires Node.js 20 or later and npm. The package name is provisionally
`@venjiang/mons`; it is not published yet. After publication:

```sh
npm install -g @venjiang/mons
mons status
mons pair
```

Use a writable npm global prefix as your normal user, without sudo. Keep
optional dependencies enabled: the matching native binary is in a platform
package. Global installation invokes the same service installer as curl.
Local project installation and npx cache downloads do not start the service.

To explicitly install or upgrade the Host using the package:

```sh
npx @venjiang/mons install
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
