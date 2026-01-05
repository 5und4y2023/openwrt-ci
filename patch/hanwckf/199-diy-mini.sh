#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci set luci.main.lang='zh_cn'

uci commit

uci del network.wan6
uci del network.lan.ip6assign
uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.dns_service
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci del dhcp.lan.ra_flags
uci add_list dhcp.lan.ra_flags='none'
uci del network.globals.ula_prefix


uci commit dhcp
uci commit network

#uci set wireless.default_MT7981_1_1.ssid=OpenWrt-2.4G
#uci set wireless.default_MT7981_1_1.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_1.key=66668888

#uci set wireless.default_MT7981_1_2.ssid=OpenWrt-5G
#uci set wireless.default_MT7981_1_2.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_2.key=66668888
#uci commit wireless
uci commit

sed -i '/ssrp/d' /etc/opkg/distfeeds.conf
sed -i '/helloworld/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
#sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

/etc/init.d/network restart

exit 0
