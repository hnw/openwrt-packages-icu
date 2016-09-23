# openwrt-packages-icu

This is `icu` OpenWrt port from LEDE.

# How to install binary package

```
$ echo 'src/gz hnw https://dl.bintray.com/hnw/openwrt-packages/15.05.1-ar71xx' >> /etc/opkg/customfeeds.conf
```

# How to build

To build these packages, add the following line to the feeds.conf in the OpenWrt buildroot:

```
$ echo 'src-git hnw-icu https://github.com/hnw/openwrt-packages-icu.git' >> feeds.conf
```

Then you can build packages as follows:

```
$ ./scripts/feeds update hnw-icu
$ ./scripts/feeds install icu
$ make packages/icu/compile
```
