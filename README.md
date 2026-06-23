# ipset-fast-update

![Tag](https://img.shields.io/github/tag/jfut/ipset-fast-update.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

ipset-fast-update is a fast updater for ipset IP sets.

## Usage

```bash
ipset-fast-update 1.6.1

Usage:
    ipset-fast-update -n SET_NAME [-i PATH]... [-u URL]... [-e EXCLUDE_PATH]... [OPTIONS...]

Options:
    -n IP set name of ipset
    -i include IP set from file path
    -u include IP set from url
    -e exclude IP set file path
    -d state directory (default: /var/lib/ipset-fast-update)
    -f force update
    -r alert threshold ratio (default: 80)
        If the threshold is exceeded, the list will not be updated without the -f option.
    -t temporary mode
        This option does not "/usr/libexec/ipset/ipset.start-stop save" for persistent settings.
    -v verbose mode
    -h help

    If the "iprange" command exists, then it is used for optimization.
    https://github.com/firehol/iprange
    https://github.com/firehol/packages

EXAMPLES
    ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt

    ipset-fast-update -n ALLOW_LIST_FILE \
        -i list1.txt \
        -i list2.txt \
        -i list3.txt

    ipset-fast-update -n DENY_LIST \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level1.netset \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level2.netset \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level3.netset \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level4.netset \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_anonymous.netset \
        -e exclude1.txt \
        -e exclude2.txt

    ipset-fast-update -n DENY_MIX_LIST \
        -i list1.txt \
        -i list2.txt \
        -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level1.netset
```

Local IP set file:

```bash
$ cat list1.txt
10.0.0.100
10.0.1.0/24
```

Local exclude IP set file:

CIDR entries in the exclusion IP set are matched exactly unless the [iprange](https://github.com/firehol/iprange)([package](https://github.com/firehol/packages)) command is available, in which case ranges are processed for exclusion.

```bash
$ cat exclude1.txt
192.168.0.100
192.168.1.0/24
```

## Examples

On RHEL compatible, install `ipset-service` and enable saving if you want updates to persist.

On other distributions, use `-t` to skip `/usr/libexec/ipset/ipset.start-stop save` and manage persistence with your distribution's ipset service.

- Install `ipset-service`

```bash
# RHEL/AlmaLinux/Rocky Linux 8 or later
dnf install ipset-service
```

Enable services:

```bash
systemctl enable ipset.service
```

- Edit `/etc/sysconfig/ipset-config`

```bash
IPSET_SAVE_ON_STOP="yes"
```

Create the `ALLOW_LIST_JP` set.

```bash
ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt
```

Add rules to iptables configuration.

- `iptables` command or /etc/sysconfig/iptables on RHEL compatible

```bash
# SSH
-A INPUT -p tcp -m tcp --dport 22 -m set --match-set ALLOW_LIST_JP src -j ACCEPT

# HTTP/HTTPS
-A INPUT -p tcp -m tcp --dport 80 -m set --match-set ALLOW_LIST_JP src -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -m set --match-set ALLOW_LIST_JP src -j ACCEPT

# Drop Attacks for inbound access
-A INPUT -m set --match-set DENY_LIST src -j DROP
-A INPUT -m set --match-set DENY_MIX_LIST src -j DROP

# Reject Attacks for outbound access
-A OUTPUT -m set --match-set DENY_LIST dst -j REJECT
-A OUTPUT -m set --match-set DENY_MIX_LIST dst -j REJECT
```
Add the cron job to the root crontab.

- `crontab -e`

If you are using multiple lists, it is better to create an update script and register it with cron.

```bash
# daily
# Example of ALLOW_LIST_JP only
42 01 * * * /path/to/ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt
```

## Release packaging with goreleaser

Build release artifacts locally:

```bash
just snapshot
just release
```

Generated files are stored in `dist/`.

## Release

GitHub Actions signs RPM artifacts with the GPG private key stored in `RPM_SIGNING_KEY`. If the key has a passphrase, store it in `NFPM_PASSPHRASE`.

1. Run `git tag -s vX.Y.Z -m vX.Y.Z`.
2. Run `git push origin vX.Y.Z` and wait for the Release to be created.
3. Edit the created Release.
4. Press the `Generate release notes` button and edit the release notes.
5. Press the `Update release` button.

## License

MIT

## Author

Jun Futagawa (jfut)
