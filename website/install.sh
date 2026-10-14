#!/bin/sh

# Keep the download body inside one function so a truncated piped script
# cannot start installing before the shell has parsed the complete function.
mons_install() (
    set -eu
    umask 077
    version=
    verify_only=0
    for argument in "$@"; do
        case "$argument" in
            --verify-only) verify_only=1 ;;
            --*) echo 'Usage: install.sh [--verify-only] [MAJOR.MINOR.PATCH]' >&2; exit 2 ;;
            *)
                [ -n "$argument" ] || { echo 'An explicit version cannot be empty' >&2; exit 2; }
                [ -z "$version" ] || { echo 'Only one version is allowed' >&2; exit 2; }
                version=$argument ;;
        esac
    done
    platform=$(uname -s)
    case "$platform:$(uname -m)" in
        Darwin:arm64|Darwin:aarch64) architecture=arm64; profile=macos-universal ;;
        Darwin:x86_64) architecture=x86_64; profile=macos-universal ;;
        Linux:arm64|Linux:aarch64) architecture=aarch64; profile=linux-aarch64 ;;
        Linux:x86_64) architecture=x86_64; profile=linux-x86_64 ;;
        *) echo 'Unsupported operating system or architecture' >&2; exit 1 ;;
    esac
    [ "$(id -u)" -ne 0 ] || { echo 'Run as your logged-in user, without sudo' >&2; exit 1; }
    case "$platform" in
        Darwin) required_commands='curl shasum unzip codesign lipo plutil'; temporary_base=/private/tmp ;;
        Linux) required_commands='curl sha256sum unzip jq file bash'; temporary_base=/tmp ;;
    esac
    for required_command in $required_commands; do
        command -v "$required_command" >/dev/null || { echo "Missing command: $required_command" >&2; exit 1; }
    done
    hash_file() {
        case "$platform" in
            Darwin) digest=$(shasum -a 256 "$1") || return ;;
            Linux) digest=$(sha256sum "$1") || return ;;
        esac
        printf '%s\n' "$digest" | cut -d' ' -f1
    }
    work_directory=$(mktemp -d "${TMPDIR:-$temporary_base}/mons-download.XXXXXX")
    trap 'rm -rf -- "$work_directory"' EXIT
    trap 'exit 1' HUP INT TERM
    if [ -z "$version" ]; then
        curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
            --connect-timeout 10 --max-time 30 --max-filesize 1048576 \
            --output "$work_directory/releases.json" \
            'https://api.github.com/repos/venjiang/mons.cc/releases?per_page=20'
        : >"$work_directory/versions.txt"
        if [ "$platform" = Darwin ]; then
            index=0
            while [ "$index" -lt 20 ]; do
                tag=$(plutil -extract "$index.tag_name" raw -expect string -o - "$work_directory/releases.json" 2>/dev/null) || break
                draft=$(plutil -extract "$index.draft" raw -expect bool -o - "$work_directory/releases.json")
                case "$draft:$tag" in
                    false:cli-v*)
                        candidate=${tag#cli-v}
                        case "$candidate" in
                            *[!0-9.]*|'') ;;
                            *) if printf '%s\n' "$candidate" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
                                printf '%s\n' "$candidate" >>"$work_directory/versions.txt"
                            fi ;;
                        esac ;;
                esac
                index=$((index + 1))
            done
        else
            jq -r 'if type != "array" then error("Invalid GitHub release response") else
                .[] | select(.draft == false and (.tag_name | type == "string")) |
                .tag_name | select(test("^cli-v[0-9]+\\.[0-9]+\\.[0-9]+$") and (contains("\n") | not)) |
                ltrimstr("cli-v") end' "$work_directory/releases.json" >"$work_directory/versions.txt"
        fi
        version=$(LC_ALL=C sort -t. -k1,1n -k2,2n -k3,3n "$work_directory/versions.txt" | tail -n 1)
        [ -n "$version" ] || {
            echo 'No published Mons CLI release found; choose an explicit version' >&2; exit 1;
        }
    fi
    case "$version" in
        *[!0-9.]*|'') echo 'Invalid release version; expected MAJOR.MINOR.PATCH' >&2; exit 1 ;;
    esac
    if ! printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        echo 'Invalid release version; expected MAJOR.MINOR.PATCH' >&2
        exit 1
    fi
    package_name="mons-$version-$profile"
    release_base="https://github.com/venjiang/mons.cc/releases/download/cli-v$version"
    archive="$work_directory/$package_name.zip"
    echo "Downloading Mons $version for $platform $architecture"
    curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 10 --max-time 120 --max-filesize 52428800 \
        --output "$archive" "$release_base/$package_name.zip"
    curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 10 --max-time 30 --max-filesize 4096 \
        --output "$archive.sha256" "$release_base/$package_name.zip.sha256"
    expected_sha256=$(awk 'NR == 1 { print $1 }' "$archive.sha256")
    if ! printf '%s\n' "$expected_sha256" | grep -Eq '^[a-f0-9]{64}$'; then
        echo 'Invalid release checksum' >&2; exit 1
    fi
    actual_sha256=$(hash_file "$archive")
    [ "$actual_sha256" = "$expected_sha256" ] || { echo 'Release checksum mismatch' >&2; exit 1; }
    unzip -Z1 "$archive" >"$work_directory/entries.txt"
    while IFS= read -r entry; do
        case "$entry" in
            /*|..|../*|*/../*|*/..) echo 'Unsafe archive path' >&2; exit 1 ;;
            "$package_name/"*|__MACOSX/*) ;;
            *) echo 'Unexpected archive root' >&2; exit 1 ;;
        esac
    done <"$work_directory/entries.txt"
    package_directory="$work_directory/$package_name"
    mkdir -p "$package_directory/licenses"
    # Stream exact members into directories created here. Do not let archive
    # symlinks or directory entries choose extraction destinations.
    payloads='mons install.sh THIRD_PARTY_NOTICES.txt SBOM.spdx.json
        licenses/quicz-MIT.txt licenses/MPL-2.0.txt licenses/usrsctp-BSD-3-Clause.txt
        licenses/mbedtls-Apache-2.0.txt licenses/plog-MIT.txt licenses/nlohmann-json-MIT.txt licenses/zig-runtime-MIT.txt'
    if [ "$platform" = Linux ]; then payloads="$payloads licenses/musl-MIT.txt"; fi
    for payload in $payloads; do
        member="$package_name/$payload"
        [ "$(grep -Fxc "$member" "$work_directory/entries.txt" || true)" = 1 ] || {
            echo "Missing or duplicate package file: $payload" >&2; exit 1;
        }
        unzip -p "$archive" "$member" >"$package_directory/$payload"
        [ -s "$package_directory/$payload" ] || { echo "Empty package file: $payload" >&2; exit 1; }
    done
    binary="$package_directory/mons"
    sbom="$package_directory/SBOM.spdx.json"
    binary_sha256=$(hash_file "$binary")
    if [ "$platform" = Darwin ]; then
        [ "$(plutil -extract packages.0.name raw -o - "$sbom")" = mons ] &&
        [ "$(plutil -extract packages.0.SPDXID raw -o - "$sbom")" = SPDXRef-Package-Mons-host ] &&
        [ "$(plutil -extract packages.0.versionInfo raw -o - "$sbom")" = "$version" ] &&
        [ "$(plutil -extract packages.0.checksums.0.algorithm raw -o - "$sbom")" = SHA256 ] &&
        [ "$(plutil -extract packages.0.checksums.0.checksumValue raw -o - "$sbom")" = "$binary_sha256" ] || {
        echo 'Host SBOM does not match downloaded binary/version' >&2; exit 1;
        }
    else
        jq -e --arg version "$version" --arg sha "$binary_sha256" --arg profile "$profile" '
            .packages[0].name == "mons" and .packages[0].SPDXID == "SPDXRef-Package-Mons-host" and
            .packages[0].versionInfo == $version and .packages[0].checksums[0].algorithm == "SHA256" and
            .packages[0].checksums[0].checksumValue == $sha and
            (.packages[0].sourceInfo | startswith("component=host; target=" + $profile + "; profile=default-ice-disabled")) and
            ([.packages[].name] | sort) == ["QR Code generator", "SQLite", "Zig standard/runtime", "mons", "musl", "quicz"]
        ' "$sbom" >/dev/null || { echo 'Host SBOM does not match downloaded binary/version' >&2; exit 1; }
    fi
    chmod 755 "$binary" "$package_directory/install.sh"
    if [ "$platform" = Darwin ]; then
        lipo "$binary" -verify_arch "$architecture"
        codesign --verify --strict "$binary"
    else
        case "$architecture" in x86_64) machine=x86-64 ;; aarch64) machine='ARM aarch64' ;; esac
        description=$(LC_ALL=C file -b "$binary")
        case "$description" in
            "ELF 64-bit LSB executable, $machine,"*'statically linked'*) ;;
            *) echo 'Linux binary architecture or linkage mismatch' >&2; exit 1 ;;
        esac
    fi
    [ "$("$binary" --version)" = "mons $version protocol 1" ] || {
        echo 'Downloaded Mons version or protocol mismatch' >&2; exit 1;
    }
    if [ "$verify_only" = 1 ]; then
        echo "Mons $version verified; no installation or service changes"
        exit 0
    fi
    if [ "$platform" = Linux ]; then bash "$package_directory/install.sh" "$binary";
    else sh "$package_directory/install.sh" "$binary"; fi
    echo "Next: $HOME/.local/bin/mons status"
    echo "Pair when ready: $HOME/.local/bin/mons pair"
)

mons_install "$@"
