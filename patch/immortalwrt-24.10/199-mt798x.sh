#!/bin/sh

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
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/mediatek/filogic/kmods/6.6.110-1-927b5064be0608a0f5695442c79b0938' /etc/opkg/distfeeds.conf
sed -i '$a src/gz core https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf

echo > /etc/opkg/distfeeds.conf
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/mediatek/filogic/kmods/6.6.110-1-927b5064be0608a0f5695442c79b0938' /etc/opkg/distfeeds.conf
sed -i '$a src/gz immortalwrt_core https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_base https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/base' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_luci https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/luci' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_packages https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_routing https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/routing' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_telephony https://mirrors.pku.edu.cn/openwrt/releases/24.10.4/packages/aarch64_cortex-a53/telephony' /etc/opkg/distfeeds.conf
sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/packages-24.10/aarch64_cortex-a53/kiddin9' /etc/opkg/customfeeds.conf

#cp /etc/my-clash /etc/openclash/core/clash_meta
#chmod +x /root/open-wifi.sh

#uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
#uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-2.4G
#uci commit wireless
#uci commit

#/etc/init.d/network restart >/dev/null 2>&1
exit 0
