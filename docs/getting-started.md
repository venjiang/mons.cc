# Getting started

Mons is currently in development. Start with the
[availability and installation requirements](installation.md). Native Host
preview downloads and the curl installer use GitHub Releases. Public app
distribution links and the npm installation channel are not available yet.

## Choose a connection

An ordinary SSH connection uses the address, port, username and credentials
you configure in the iPhone app. A paired connection uses the Mons Host and
can use verified direct routes or the secure relay fallback. Pairing does not
require the phone and host to share the same Wi-Fi network.

Configure SSH access first. The Host installer does not enable macOS Remote
Login or change Linux SSH settings for you.

## Pair the phone with a Mons Host

On the host:

```sh
mons --version
mons status
mons pair
```

Scan the displayed QR code using Mons on your iPhone, or use the pairing link
in the app. Complete the app's pairing flow before the offer expires. If it
expires, run `mons pair` again to create a new offer. Keep pairing codes and
links private.

After pairing, select the connection in the app and open a session. Herdr and
tmux must already be installed on the host if you want to discover and attach
to their sessions. Mons does not install a multiplexer or start a coding agent
for you. Plain SSH opens a shell without requiring either multiplexer.

## Existing sessions

Mons attaches to the selected existing Herdr/tmux target. Leaving the terminal
view does not stop that persistent host session. Reconnection tries to return
to the same target; if it has been removed on the host, choose an available
session rather than expecting a replacement to appear automatically.

Plain SSH is different: saving its entry does not make its remote shell a
persistent multiplexer session. Use Herdr or tmux when persistence is needed.

## Host identity

The app may ask you to trust an SSH host key. Compare the fingerprint with the
actual server before accepting it. This applies to Mac and Linux hosts. A
changed fingerprint should be investigated, not dismissed by deleting trust
or pairing data blindly.

## Coding-agent workflows

Use your existing agent in the host terminal and attach to that working
session from the phone. Mons provides the terminal and session access; agent
accounts, model subscriptions and host compute are separate. Background agent
notifications, approval interfaces and structured chat are planned features.

## Useful Host commands

```sh
mons status          # Host service status
mons logs            # Follow new log entries
mons logs -n 200     # Read recent entries
mons logs -l debug   # Follow entries including debug, when the Host records them
mons unpair          # Revoke pairing; use only when you intend to unpair
```

`-l debug` filters displayed records; it cannot recover debug events that the
running service did not record. See [Troubleshooting](troubleshooting.md) for
logs, routes and useful bug-report details.
