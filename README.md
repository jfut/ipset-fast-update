# ipset-fast-update

Fast update of IP set for ipset.

## Usage

```
ipset-fast-update 1.0

Usage:
    ipset-fast-update -n SET_NAME -u URL [-u URL]... [-f] [-r 35] [-v] [-h]

    Options:
        -f fource update
        -d state directory (default: /var/lib/ipset-fast-update)
        -n IP set name of ipset
        -u IP set url
        -r alert threshold ratio (default: 35)
        -v verbose mode
        -h help

    If the "iprange" command exists, then it is used for optimization.
    https://github.com/firehol/iprange

    EXAMPLES
        ipset-fast-update -n WHITELIST_JP -u https://ipv4.fetus.jp/jp.txt

        ipset-fast-update -n BLACKLIST \
           -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset \
           -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level2.netset \
           -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level3.netset \
           -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level4.netset \
           -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_botcc.ipset
```

## Examples

(Optional) Save current ipsets when stopping ipset service on RHEL/CentOS.

- Edit `/etc/sysconfig/ipset-config`

```
IPSET_SAVE_ON_STOP="yes"
```

Save them manually on RHEL/CentOS 7.

```
/usr/libexec/ipset/ipset.start-stop save
```

Create the `WHITELIST_JP` set.

```
ipset-fast-update -n WHITELIST_JP -u https://ipv4.fetus.jp/jp.txt
```

Add rules to iptables configuration.

- `iptables` command or /etc/sysconfig/iptables on RHEL/CentOS

```
# SSH
-A INPUT -p tcp -m tcp --dport 22 -m set --match-set WHITELIST_JP src -j ACCEPT

# HTTP/HTTPS
-A INPUT -p tcp -m tcp --dport 80 -m set --match-set WHITELIST_JP src -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -m set --match-set WHITELIST_JP src -j ACCEPT
```

Add the cron job to the root crontab.

- `crontab -e`

```
# daily
01 23 * * * /path/to/ipset-fast-update -n WHITELIST_JP -u https://ipv4.fetus.jp/jp.txt
```

## License

MIT

## Author

Jun Futagawa (jfut)

