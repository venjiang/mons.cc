# Troubleshooting

## Host download returns 404

Check the requested URL and version against
[official downloads](https://mons.cc/downloads/). The curl installer and
`mons update` use the website's platform manifest; GitHub is an optional mirror,
not a required API. A missing entry, manifest, platform ZIP, checksum or installer
stops installation. GitHub's automatic `Source code` archives are documentation
snapshots, not replacement binary packages. Do not bypass a failed checksum.

To verify the published preview without installing or changing the service:

```sh
curl -fsSL https://mons.cc/install.sh | sh -s -- --verify-only
```

The curl entry installs the CLI and its local Host service only, not the mobile
app or Relay. See [Installation](installation.md) for platform requirements and
the macOS ad-hoc signing limitation.

## Collect the basic facts

Record the app version, Host version, operating systems, the action that
failed and its time. For a paired connection, note the route shown in the app
and whether the phone used Wi-Fi or cellular. Keep the original error text.

```sh
command -v mons
mons --version
mons status
mons logs -n 200
```

Different app and Host version numbers are normal: they are separate
components. The CLI's version alone does not establish which service binary
is running, especially when multiple installation entries exist.

## `mons` is not found

The native installer's CLI is normally `~/.local/bin/mons`; ensure its
directory is in PATH. npm uses its own global bin location. Restarting the
shell or refreshing its command cache may be needed after an installation.
Check the installer's final output before assuming installation succeeded.

## Pairing fails or expires

Confirm `mons status` reports an available Host service and inspect logs for
the corresponding failure. A phone and host do not need the same LAN to pair,
but the configured relay still has to be reachable. A timed-out offer should
be replaced by running `mons pair` again. Do not reuse or publicly share an
expired or active pairing link.

## SSH connection or host-key verification fails

Check the intended address, port, username, SSH server and authentication
method. Enable Remote Login separately on macOS when needed. The app supports
Ed25519 and ECDSA private keys in the currently supported import format; RSA
private-key import is not supported. Do not work around this by posting the
private key in an issue.

Verify the fingerprint on the actual server before accepting a new or changed
host key. The verification step should not be mistaken for an authenticated
terminal connection.

## A route is unavailable

Ordinary SSH uses the configured endpoint. Paired connections choose among
verified routes and a secure relay fallback. Network labels alone are not
proof of a successful terminal connection. Tailscale must already be set up
and the endpoint must actually be reachable for a Tailnet route to work.
P2P availability varies with NAT and network conditions; no route is promised
to bypass every firewall or carrier restriction.

For failures during a switch, report the original and new network types,
whether Tailscale was active, the route before and after the switch, and
whether the same session resumed. A later successful LAN connection does not
by itself explain an earlier cellular failure.

## Session commands are unknown or a session is stopped

Run `command -v mons`, `mons --version` and `mons session --help`. Source merges
and documentation changes do not update an installed binary, and `mons update`
only retrieves a published version. Do not delete identity/pairing files to try
to enable a missing command.

On a supporting build, `mons ls --json` shows the real names and states.
`mons session attach work` can create, start or enter `work`; `mons open work`
still works. A saved app display alias is not the real CLI session name.

**`mons session stop work` terminates pane processes.** It keeps saved state,
not the original running processes. Stop is not detach, and there is no CLI
`session detach` command. `mons session delete work` permanently removes saved
state, requires a stopped named session and cannot delete `default`. Missing
names, wrong case, unknown/unreadable status and failed state queries are
rejected; preserve the error instead of deleting directories manually. Do not
attach/open and delete the same session concurrently. For a leading hyphen use
`--`, such as `mons session attach -- -work`. See the
[session guide](getting-started.md#stop-or-permanently-delete-a-session).

## Host logs and app diagnostics

`mons logs` follows new entries. `mons logs -n 200` reads recent history;
`mons logs -l debug` lowers the display filter. This filter does not change
the running service's recording level or recreate missing records.

Use the app's diagnostic copy/share action when available. Include the
relevant incident window and any session or attempt identifier needed to
correlate it. Session names, identifiers and network addresses can be included
when you choose to share them. Review a report before posting it publicly;
never include passwords, private keys, tokens or active pairing links.
Terminal content and screenshots may also contain information you do not
want published.

## Report the problem

Use the [bug report form](https://github.com/venjiang/mons.cc/issues/new/choose).
Include expected and actual behavior, reproducible steps, versions, network
conditions and relevant errors. If the problem cannot be repeated, say so and
provide the observed time and context instead of guessing a cause.

For a suspected vulnerability, follow [the security-reporting policy](../SECURITY.md)
and do not put exploit details in a public issue.
