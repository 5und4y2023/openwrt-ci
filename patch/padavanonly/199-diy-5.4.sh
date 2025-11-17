#!/bin/sh

uci set firewall.@defaults[0].input='ACCEPT'
uci commit firewall
mv /diy4me/socat /etc/config/socat
mv /diy4me/zerotier /etc/config/zerotier

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci set wireless.default_MT7981_1_1.ssid=CMCC-RTG
uci set wireless.default_MT7981_1_1.encryption=psk2+ccmp
uci set wireless.default_MT7981_1_1.key=Rtg@168$

uci set wireless.default_MT7981_1_2.ssid=CMCC-RTG-5G
uci set wireless.default_MT7981_1_2.encryption=psk2+ccmp
uci set wireless.default_MT7981_1_2.key=Rtg@168$
uci commit wireless

uci commit

sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -i '/Modem/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
sed -i '/filogic/d' /etc/opkg/distfeeds.conf

#sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

/etc/init.d/socat restart
/etc/init.d/zerotier restart
/etc/init.d/network restart >/dev/null 2>&1
/etc/init.d/firewall restart >/dev/null 2>&1
/etc/init.d/dnsmasq restart >/dev/null 2>&1
/etc/init.d/dropbear restart >/dev/null 2>&1
exit 0
