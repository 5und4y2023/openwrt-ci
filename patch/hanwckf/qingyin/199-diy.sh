#!/bin/sh


# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

#其他网络设置
#uci set network.lan.ipaddr=192.168.23.1
#uci del network.lan.ip6assign
#uci commit network

#uci del dhcp.lan.ra
#uci del dhcp.lan.dhcpv6
#uci del dhcp.lan.ndp
#uci commit dhcp

uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.ra_flags
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.dns_service
uci commit dhcp
uci del network.wan6
uci del network.lan.ip6assign
uci del network.globals.ula_prefix
uci commit network
uci commit

#uci set wireless.default_MT7981_1_1.ssid=TK888
uci set wireless.default_MT7981_1_1.encryption=psk2+ccmp
uci set wireless.default_MT7981_1_1.key=3305349535

#uci set wireless.default_MT7981_1_2.ssid=TK888
uci set wireless.default_MT7981_1_2.encryption=psk2+ccmp
uci set wireless.default_MT7981_1_2.key=3305349535
uci commit wireless

uci commit

sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
#sed -i '$a src/gz kiddin9 https://dl.openwrt.ai/packages-24.10/aarch64_generic/kiddin9' /etc/opkg/customfeeds.conf

sed -i 's/root::0:0:99999:7:::/root:$1$qingyin$dS8yR.guqj1QRuvRH2zt3.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$qingyin$dS8yR.guqj1QRuvRH2zt3.:0:0:99999:7:::/g' /etc/shadow

OPENCLASH_FILE="/etc/config/openclash"
if [ -f "$OPENCLASH_FILE" ]; then
    tar -zxf /etc/clash-linux-arm64.tar.gz -C /etc/openclash/core/
    mv /etc/openclash/core/clash /etc/openclash/core/clash_meta
    rm -rf /etc/clash-linux-arm64.tar.gz
fi

mv /etc/qingyin.sh /lib/qingyin.sh
chmod 0755 /lib/qingyin.sh
mv /etc/QINGYINSSIDMAC2.sh /etc/init.d/QINGYINSSIDMAC2.sh
chmod 0755 /etc/init.d/QINGYINSSIDMAC2.sh

/etc/init.d/network restart

exit 0
