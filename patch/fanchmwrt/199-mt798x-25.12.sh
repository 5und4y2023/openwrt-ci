
#!/bin/sh

uci set network.lan.ip6assign=64
uci del network.globals.ula_prefix
uci set dhcp.lan.dns_service='0'
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci set dhcp.lan.ra='server'
uci del dhcp.lan.ra_flags
uci add_list dhcp.lan.ra_flags='none'
uci set network.lan.delegate='0'
uci set network.lan.ip6ifaceid='random'
uci commit dhcp
uci commit network

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci commit

sed -i '/passwall/d' /etc/apk/repositories.d/distfeeds.list
sed -i 's#downloads.immortalwrt.org#mirrors.vsean.net/openwrt#g' /etc/apk/repositories.d/distfeeds.list
sed -i '/targets/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz https://mirrors.pku.edu.cn/openwrt/releases/25.12.2/targets/mediatek/filogic/kmods/6.12.74-1-60d938adcb727697d3015e4285d4c290/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz core https://mirrors.pku.edu.cn/openwrt/releases/25.12.2/targets/x86/64/packages' /etc/opkg/distfeeds.conf

sed -i '/helloworld/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/passwall/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/modem/d' /etc/apk/repositories.d/distfeeds.list
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/apk/repositories.d/distfeeds.list
sed -i '/mediatek/d' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/targets/mediatek/filogic/kmods/6.6.110-1-6a9e125268c43e0bae8cecb014c8ab03/packages.adb' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/25.12.2/targets/mediatek/filogic/packages/packages.adb' /etc/apk/repositories.d/distfeeds.list


#sed -i 's/root::0:0:99999:7:::/root:$1$y2IgmKjI$uhkjDM.X5BMHsbf11Azms1:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$y2IgmKjI$uhkjDM.X5BMHsbf11Azms1:0:0:99999:7:::/g' /etc/shadow

uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-2.4G



#uci set wireless.default_radio1.encryption='psk2+ccmp'
#uci set wireless.default_radio0.encryption='psk2+ccmp'
#uci set wireless.default_radio1.key='TikTok888.'
#uci set wireless.default_radio0.key='TikTok888.'
#uci set wireless.default_radio0.macaddr='random'
#uci set wireless.default_radio1.macaddr='random'
uci commit wireless
uci commit

/etc/init.d/network restart >/dev/null 2>&1
exit 0
