# ipset-fast-update

Fast update of IP set for ipset.

## Usage

```
ipset-fast-update 1.1

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
        # Japanese IPs
        # Soruce: https://ipv4.fetus.jp/jp
        ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt

        # An ipset made from blocklists that track attacks, during about the last 48 hours.
        # (includes: blocklist_de dshield_1d greensnow)
        # Source: http://iplists.firehol.org/?ipset=firehol_level2
        ipset-fast-update -n DENY_LIST_ATTACK \
            -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level2.netset

        # EmergingThreats.net Command and Control IPs
        # IBM X-Force Exchange Botnet Command and Control Servers
        # Source: http://iplists.firehol.org/?ipset=et_botcc
        # Source: http://iplists.firehol.org/?ipset=xforce_bccs
        ipset-fast-update -n DENY_LIST_BOT_CC \
            -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_botcc.ipset \
            -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xforce_bccs.ipset

        # An ipset that includes all the anonymizing IPs of the world.
        # (includes: anonymous bm_tor dm_tor firehol_proxies tor_exits)
        # Source: http://iplists.firehol.org/?ipset=firehol_anonymous
        ipset-fast-update -n DENY_LIST_ANONYMOUS_TOR \
            -u https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_anonymous.netset
```

## Examples

(Optional) Save current ipsets when stopping ipset service on RHEL/CentOS 7 and 8.

- Install `ipset-service`

```
# RHEL/CentOS 7
yum install ipset-service

# RHEL/CentOS 8
dnf install ipset-service
```

Enable services:

```
systemctl enable ipset.service
```

- Edit `/etc/sysconfig/ipset-config`

```
IPSET_SAVE_ON_STOP="yes"
```

Create the `ALLOW_LIST_JP` set.

```
ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt
```

Add rules to iptables configuration.

- `iptables` command or /etc/sysconfig/iptables on RHEL/CentOS

```
# SSH
-A INPUT -p tcp -m tcp --dport 22 -m set --match-set ALLOW_LIST_JP src -j ACCEPT

# HTTP/HTTPS
-A INPUT -p tcp -m tcp --dport 80 -m set --match-set ALLOW_LIST_JP src -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -m set --match-set ALLOW_LIST_JP src -j ACCEPT

# Drop Attacks for inbound access
-A INPUT -m set --match-set DENY_LIST_ATTACK src -j DROP
-A INPUT -m set --match-set DENY_LIST_BOT_CC src -j DROP
-A INPUT -m set --match-set DENY_LIST_ANONYMOUS_TOR src -j DROP

# Reject Attacks for outbound access
-A OUTPUT -m set --match-set DENY_LIST_ATTACK dst -j REJECT
-A OUTPUT -m set --match-set DENY_LIST_BOT_CC dst -j REJECT
-A OUTPUT -m set --match-set DENY_LIST_ANONYMOUS_TOR dst -j REJECT
```
Add the cron job to the root crontab.

- `crontab -e`

If you are using multiple lists, it is better to create an update script and register it with cron.

```
# daily
# Example of ALLOW_LIST_JP only
42 01 * * * /path/to/ipset-fast-update -n ALLOW_LIST_JP -u https://ipv4.fetus.jp/jp.txt
```

## License

MIT

## Author

Jun Futagawa (jfut)

