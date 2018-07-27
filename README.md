# ipset-fast-update

fast update ipset list.

## Usage

```
ipset-fast-update 1.0

Usage:
    ipset-fast-update -n SET_NAME -u URL [-u URL]... [-f] [-r 35] [-v] [-h]

    Options:
        -f fource update
        -n ipset list name
        -u ipset source file url
        -r alert threshold ratio (default: 35)
        -v verbose mode
        -h help

    STATE_DIR: /path/to/.ipset-fast-update

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

## License

MIT

## Author

Jun Futagawa (jfut)

