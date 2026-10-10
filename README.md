<img src="website/assets/mons-logo.svg" alt="Mons logo" width="128" height="128">

# Mons

**Your terminal. Agent ready.**

Mons is a persistent remote terminal for iPhone, designed for coding-agent
workflows. Connect to a host over SSH, return to an existing Herdr or tmux
session, and keep using the same shell and working context from your phone.

**Status: in development.** The website is Coming Soon. This repository has no
public product release yet, and the npm package has not been published.
Installation examples describe the intended public flow; they are not a
promise that a public download is available today.

## What Mons does

- Provides a real terminal for shells, command-line tools and coding agents.
- Attaches to existing Herdr/tmux sessions without stopping them when you leave.
- Supports ordinary SSH connections and pairing with a Mons Host.
- Uses available direct connections with a secure relay fallback for paired hosts.
- Provides mobile terminal controls, session recovery and diagnostic tools.

Agent notifications, remote approval and structured chat interfaces are future
work. They are not advertised as currently available features.

## Start here

- [Website](https://mons.cc)
- [Installation](docs/installation.md) — curl is the default; npm/npx is an alternative for developers.
- [Getting started](docs/getting-started.md) — connections, pairing and sessions.
- [Troubleshooting](docs/troubleshooting.md) — connection problems, logs and diagnostics.
- [Report a bug or request a feature](https://github.com/venjiang/mons.cc/issues/new/choose)
- [Security reports](SECURITY.md)

The iPhone app and native Host are separate components. Host packages target
macOS Apple Silicon/Intel and Linux x86_64/arm64. The iPhone app's public
distribution links will be added when available.

## This repository

This is the public website, user-documentation and feedback repository.
Website source lives in [`website/`](website/). Product releases will be
attached to [GitHub Releases](https://github.com/venjiang/mons.cc/releases)
rather than committed as large binary files.

The website keeps its existing static HTML/CSS/JavaScript layout. To preview it:

```sh
python3 -m http.server 8000 --bind 127.0.0.1 --directory website
```

Open `http://localhost:8000`. Production asset-version markers are rendered by
the release packager; a local preview does not make downloads available.
Deployment is handled separately from this public repository.

The repository's [Apache-2.0 license](LICENSE) covers the website and
documentation source here. Product binaries have their own licensing and
third-party notices; they are not made open source by this repository.
