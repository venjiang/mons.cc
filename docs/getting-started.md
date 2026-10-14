# Getting started

Install the Mons CLI and local user-level Host service using the
[installation guide](installation.md). Native macOS and Linux development
preview packages are available from GitHub Releases; the curl installer
downloads the matching binary and starts the Host service. This repository
does not provide mobile app or Relay downloads/installations.

## Choose a connection

An ordinary SSH connection uses the address, port, username and credentials
you configure in the iPhone app. A paired connection uses the Mons Host and
can use verified direct routes or the secure relay fallback. Pairing does not
require the phone and host to share the same Wi-Fi network.

Configure SSH access first. The Host installer does not enable macOS Remote
Login or change Linux SSH settings for you.

## Connect with Manual SSH

1. On macOS, enable **System Settings → General → Sharing → Remote Login**
   for your user. On Linux, use an existing SSH server and valid credentials.
2. In Mons, choose **Add Connection → Manual SSH**. Enter a connection name,
   reachable host address, SSH port (normally `22`), username, and password or
   supported private key, then tap **Save**.
3. Compare the SSH fingerprint with the actual server, then choose
   **Trust Host & Connect**.
4. Select an existing Herdr/tmux session, or **Open Plain SSH** for a shell.

Manual SSH does not require Mons Host. The endpoint must be reachable from
your phone; outside your local network, use your existing remote-access or VPN
setup. See [Troubleshooting](troubleshooting.md) for supported key formats.

## Pair the phone with a Mons Host

On the host:

```sh
mons --version
mons status
mons pair
```

Keep `mons pair` running. In the app, choose **Add Connection → Easy Pair**,
then **Scan QR Code**, or paste the link and tap **Add Pairing Link**.
Complete the app's pairing flow before the offer expires. If it
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

For example, with tmux already installed, create a session on the host:

```sh
tmux new -s work
```

Start your tools or coding agent there, then select that session in Mons.
Try leaving the terminal view and reconnecting to the same target. Keep the
host awake and the session running while you need remote access.

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

## Beta feedback

Try a connection, keyboard input, session recovery, and Wi-Fi/cellular changes.
If something fails, note the time, route, steps, and original error. Use the
[bug report form](https://github.com/venjiang/mons.cc/issues/new/choose).
Include app/Host versions and expected versus actual behavior. Review
diagnostics and screenshots before sharing; keep credentials and active
pairing links private.
