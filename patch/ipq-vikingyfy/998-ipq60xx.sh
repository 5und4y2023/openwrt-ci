#!/bin/sh

sed -i '/nss/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/sqm/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/qualcommax/d' /etc/apk/repositories.d/distfeeds.list
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/immortalwrt/snapshots/targets/qualcommax/ipq60xx/packages/packages.adb' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/immortalwrt/snapshots/targets/qualcommax/ipq60xx/kmods/6.12.35-1-d0229791e1a081cf44229b6bac87670d/packages.adb' /etc/apk/repositories.d/distfeeds.list
# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

# wifi设置
uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-2.4G
uci set wireless.radio0.txpower='20'
uci set wireless.radio1.txpower='20'
uci commit wireless
uci commit

/etc/init.d/network restart

exit 0
