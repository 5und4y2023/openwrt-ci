#!/bin/sh

uci -q get system.@imm_init[0] > "/dev/null" || uci -q add system imm_init > "/dev/null"

if ! uci -q get system.@imm_init[0].system_chn > "/dev/null"; then
	uci -q batch <<-EOF
		set system.@system[0].timezone="CST-8"
		set system.@system[0].zonename="Asia/Shanghai"

		delete system.ntp.server
		add_list system.ntp.server="ntp.tencent.com"
		add_list system.ntp.server="ntp1.aliyun.com"
		add_list system.ntp.server="ntp.ntsc.ac.cn"
		add_list system.ntp.server="cn.ntp.org.cn"

		set system.@imm_init[0].system_chn="1"
		commit system
	EOF
fi

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

#其他网络设置
uci commit

sed -i '/modem/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/passwall/d' /etc/apk/repositories.d/distfeeds.list
sed -i 's#downloads.openwrt.org#mirrors.pku.edu.cn/openwrt#g' /etc/apk/repositories.d/distfeeds.list
sed -i '/filogic/d' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/25.12.4/targets/mediatek/filogic/kmods/6.12.87-1-82967b4996cac5f682958cca092c9ab1/packages.adb' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/25.12.4/targets/mediatek/filogic/packages/packages.adb' /etc/apk/repositories.d/distfeeds.list

#sed -i 's/https/http/g' /etc/opkg/distfeeds.conf


# wifi设置
#WIFINAME=$(ip link show br-lan 2>/dev/null | awk '/link\/ether/{split($2,m,":");print toupper(m[5]m[6])}')
uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-2.4G
uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
#uci set wireless.default_radio0.encryption=psk2+ccmp
#uci set wireless.default_radio1.encryption=psk2+ccmp
#uci set wireless.default_radio0.key=password
#uci set wireless.default_radio1.key=password
uci commit wireless


#uci commit dhcp
uci commit network

uci commit
/etc/init.d/network restart
#/etc/init.d/odhcpd restart

exit 0
