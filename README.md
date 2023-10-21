# ipset-fast-update

![Tag](https://img.shields.io/github/tag/jfut/ipset-fast-update.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Fast update of IP set for ipset.

## Usage

```
ipset-fast-update 1.4

Usage:
    ipset-fast-update -n SET_NAME [-i PATH]... [-u URL]... [OPTIONS...]

    Options:
        -n IP set name of ipset
        -i IP set file path
        -u IP set url
        -d state directory (default: /var/lib/ipset-fast-update)
        -f fource update
        -r alert threshold ratio (default: 80)
           If the threshold is exceeded, the list will not be updated without the -f option.
        -t temporary mode
           This option does not "/usr/libexec/ipset/ipset.start-stop save" for persistent settings.
        -v verbose mode
        -h help

    If the "iprange" command exists, then it is used for optimization.
    https://github.com/firehol/iprange

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
           -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_anonymous.netset

        ipset-fast-update -n DENY_MIX_LIST \
           -i list1.txt \
           -i list2.txt \
           -u https://raw.githubusercontent.com/borestad/firehol-mirror/main/firehol_level1.netset
```

## Examples

(Optional) Save current ipsets when stopping ipset service on RHEL/CentOS 7 and 8.

- Install `ipset-service`

```bash
# RHEL/AlmaLinux/Rocky Linux 8 or later
dnf install ipset-service

# RHEL/CentOS 7
yum install ipset-service
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

- `iptables` command or /etc/sysconfig/iptables on RHEL/CentOS

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

## License

MIT

## Author

Jun Futagawa (jfut)

