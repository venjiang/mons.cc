# Getting started

Install the Mons CLI and local user-level Host service using the
[installation guide](installation.md). Native macOS and Linux development
preview packages are available from the official website; the curl installer
downloads the matching binary and starts the Host service. This repository
does not provide mobile app or Relay downloads/installations.

## Check the installed CLI's capabilities

```sh
command -v mons
mons --version
mons --help
mons session --help
```

The session guide below requires a build whose help lists `open`, `ls` and
`session attach/stop/delete`. A source merge is not a binary release: an older
published CLI does not gain commands from a documentation update. If `session`
is unknown, use the features of that installed release until a supporting build
is available. `mons update` only installs versions in the official catalogue;
it does not fetch an unpublished source build.

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
4. Select an existing built-in or external Herdr/tmux session, or **Open SSH**
   for a shell (called Open Plain SSH in older app builds).

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

After pairing, select the connection in the app and open a session. A Host build
with bundled Herdr prepares its own private persistent terminal; no separate
Herdr/tmux installation is needed for those sessions. External Herdr/tmux must
be installed and started separately. Mons does not install or start a coding
agent. An ordinary SSH shell needs neither multiplexer.

## Create or enter a built-in session

With a CLI that supports the commands above, run on the host:

```sh
mons                       # launch or attach to default in an interactive terminal
mons open                  # explicitly open default
mons session attach work   # create, start or attach to work
mons open work             # the existing named-session entry still works
mons ls                    # list private sessions
mons ls --json             # inspect exact names and running state
```

`session attach` requires a name. Bare `mons` only opens default when both input
and output are TTYs; otherwise it shows help. Inside an existing Mons terminal,
bare `mons` refuses recursive attachment. Start tools or an agent in `work`, then
select the same session in the app. These CLI commands only manage Mons's
private bundled sessions, not an external Herdr/tmux session with the same name.

App display aliases do not rename the actual host session. CLI commands use the
real name from `mons ls`, including its exact case. Names are 1–64 ASCII letters,
digits, dots, underscores or hyphens; `.` and `..` are not valid names. A leading
hyphen needs `--`, for example `mons session attach -- -work`; stop/delete use
the same separator. `mons session attach --help` shows help, while
`mons session attach -- --help` selects a session literally named `--help`.

## Existing sessions

Mons attaches to the selected existing built-in or external Herdr/tmux target. Leaving the terminal
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

## Stop or permanently delete a session

**Stopping ends the session's pane processes, including shells, tools and
agents. Save work first and confirm the exact name with `mons ls --json`.**

```sh
mons session stop work
```

Stop keeps the session directory and saved state, but it is not detach and a
later attach does not restore the original processes. `mons session stop default`
is allowed; it does not uninstall the Host or permanently disable default.

**Deletion is irreversible.** Only remove an already stopped named session
whose saved state you no longer need:

```sh
mons session delete work
```

Delete never stops a running session for you and cannot delete `default`.
Missing names, unknown/unreadable status and failed state queries are rejected.
Do not bypass these checks by removing session files, and do not attach/open
and delete the same session concurrently. Use `mons session --help`, or append
`--help` to one of the three session subcommands, for syntax.
There is no `mons session detach`, `kill`, `close` or real-session rename command.
Leaving the app's persistent terminal is different from stopping it.

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
mons --licenses      # Read embedded dependency notices
mons update --check  # Check the published platform version, without installing
mons help            # Show global help; --help and -h are aliases
```

`-l debug` filters displayed records; it cannot recover debug events that the
running service did not record. See [Troubleshooting](troubleshooting.md) for
logs, routes and useful bug-report details.

`mons log` aliases `logs`. `-f`/`--follow` explicitly follows; do not combine it
with `-n` (1–2000 recent lines). `-l`/`--level` controls the display filter only.
`mons --version` and `mons -V` show binary/protocol versions; there is no
`mons version` subcommand. `mons update` performs an explicit published-version
native upgrade from the website and may briefly restart the Host; it does not
downgrade a newer local build. npm distribution is retired. Existing npm users
must explicitly migrate before using website updates; see
[Installation](installation.md#migrate-an-existing-npm-installation).

**`mons unpair` revokes all devices paired with this Host.** It is not a
service-uninstall or session-delete command. `mons serve` and `mons serve --once`
run the Host in the foreground or for one cycle and may initialize state; they
are not read-only checks. Do not start a second Host beside the installed user
service. `install` is not a native ZIP CLI command. See
[Installation](installation.md) before changing installation methods.

## Beta feedback

Try a connection, keyboard input, session recovery, and Wi-Fi/cellular changes.
If something fails, note the time, route, steps, and original error. Use the
[bug report form](https://github.com/venjiang/mons.cc/issues/new/choose).
Include app/Host versions and expected versus actual behavior. Review
diagnostics and screenshots before sharing; keep credentials and active
pairing links private.
