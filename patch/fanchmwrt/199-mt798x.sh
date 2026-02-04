
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

sed -i '/helloworld/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -i '/modem/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
sed -i '/mediatek/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/targets/mediatek/filogic/kmods/6.6.110-1-6a9e125268c43e0bae8cecb014c8ab03' /etc/opkg/distfeeds.conf
sed -i '$a src/gz core https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf

echo > /etc/opkg/distfeeds.conf
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/targets/mediatek/filogic/kmods/6.6.110-1-6a9e125268c43e0bae8cecb014c8ab03' /etc/opkg/distfeeds.conf
sed -i '$a src/gz core https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_base https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/base' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_luci https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/luci' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_packages https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_routing https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/routing' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_telephony https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/telephony' /etc/opkg/distfeeds.conf
sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/packages-25.12/aarch64_cortex-a53/kiddin9' /etc/opkg/customfeeds.conf


sed -i 's/root::0:0:99999:7:::/root:$1$y2IgmKjI$uhkjDM.X5BMHsbf11Azms1:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$y2IgmKjI$uhkjDM.X5BMHsbf11Azms1:0:0:99999:7:::/g' /etc/shadow

#uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
#uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-2.4G
uci set wireless.default_radio0.ssid=TilTok-2.4G
uci set wireless.default_radio1.ssid=TilTok-5G
uci set wireless.default_radio1.encryption='psk2+ccmp'
uci set wireless.default_radio0.encryption='psk2+ccmp'
uci set wireless.default_radio1.key='TikTok888.'
uci set wireless.default_radio0.key='TikTok888.'
#uci set wireless.default_radio0.macaddr='random'
#uci set wireless.default_radio1.macaddr='random'
uci commit wireless
uci commit

/etc/init.d/network restart >/dev/null 2>&1
exit 0
