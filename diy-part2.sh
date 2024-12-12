#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/11.1.1.1/g' package/base-files/files/bin/config_generate
# 禁用ipv6
sed -i "/ip6assign='60'/d" package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/package/helloworld


# kenzok8依赖清除，防止冲突
rm -rf feeds/packages/{adguardhome,v2ray*,alist,luci-app-alist,*aliyundrive*,*netdata*,haproxy}
rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}
