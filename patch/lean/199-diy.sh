#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit
# 设置主题
#uci set luci.main.mediaurlbase=/luci-static/design
#uci commit luci

uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.dns_service
uci del dhcp.lan.ra_flags
uci del network.globals.ula_prefix
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci del network.wan6
uci del network.lan.ip6assign

uci commit dhcp
uci commit network
sed -i 's#mirrors.tencent.com/lede#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf

sed -i '/helloworld/d' /etc/opkg/distfeeds.conf
sed -i '/ssrp/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -i '/core/d' /etc/opkg/distfeeds.conf
sed -i '/smpackage/d' /etc/opkg/distfeeds.conf
sed -i '/kwrt/d' /etc/opkg/distfeeds.conf
sed -i '/luci/d' /etc/opkg/distfeeds.conf
#sed -i '$a src/gz openwrt_luci https://mirrors.pku.edu.cn/immortalwrt/releases/18.06-k5.4-SNAPSHOT/packages/mipsel_24kc/luci' /etc/opkg/distfeeds.conf
sed -i '$a src/gz #18.06_luci https://mirrors.pku.edu.cn/immortalwrt/releases/18.06-k5.4-SNAPSHOT/packages/aarch64_cortex-a53/luci' /etc/opkg/distfeeds.conf

date_version=$(date +"%Y.%m.%d")
sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='V${date_version}'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt  '" >> /etc/openwrt_release

#sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
uci set wireless.default_radio0.ssid=OpenWrt-2.4G
uci set wireless.default_radio1.ssid=OpenWrt-5G
uci set wireless.default_radio0.encryption=psk2+ccmp
uci set wireless.default_radio1.encryption=psk2+ccmp
uci set wireless.default_radio0.key=password
uci set wireless.default_radio1.key=password
uci commit wireless
uci commit
/etc/init.d/network restart
exit 0
