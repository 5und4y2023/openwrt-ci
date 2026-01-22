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

sed -i '/modem/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.openwrt.org#mirrors.pku.edu.cn/openwrt#g' /etc/opkg/distfeeds.conf
sed -i '/filogic/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/openwrt/releases/24.10.5/targets/mediatek/filogic/kmods/6.6.119-1-6a9e125268c43e0bae8cecb014c8ab03' /etc/opkg/distfeeds.conf
sed -i '$a src/gz filogicpkg https://mirrors.pku.edu.cn/openwrt/releases/24.10.5/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
echo > /etc/opkg/customfeeds.conf
sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/releases/25.12/packages/aarch64_cortex-a53/kiddin9' /etc/opkg/customfeeds.conf

#sed -i 's/https/http/g' /etc/opkg/distfeeds.conf


# wifi设置
uci set wireless.default_radio0.ssid=OpenWrt-2.4G
uci set wireless.default_radio1.ssid=OpenWrt-5G
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
