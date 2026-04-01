#!/bin/sh

# 提取MAC地址
# br-lan
FRPMAC=$(ip link show br-lan | awk '/link\/ether/ {print $2}')

if [ -z "$FRPMAC" ]; then
    FRPMAC=$(cat /sys/class/net/br-lan/address 2>/dev/null)
fi

# eth0 和 wan
if [ -z "$FRPMAC" ]; then
    FRPMAC=$(cat /sys/class/net/eth0/address 2>/dev/null)
fi
if [ -z "$FRPMAC" ]; then
    FRPMAC=$(ip link show wan | awk '/link\/ether/ {print $2}')
fi


# 如果还不行，尝试获取第一个有MAC地址的接口
if [ -z "$FRPMAC" ]; then
    for iface in /sys/class/net/*/address; do
        FRPMAC=$(cat "$iface" 2>/dev/null | grep -v "00:00:00:00:00:00" | head -1)
        [ -n "$FRPMAC" ] && break
    done
fi

# 4. 处理MAC地址：去掉冒号并转大写
FRPMAC_CLEAN=$(echo "$FRPMAC" | tr -d ':' | tr 'a-f' 'A-F')

# 5. 组合成FRPNAME
FRPNAME="${FRPMAC_CLEAN}"


#echo "处理后MAC: $FRPMAC_CLEAN"
#echo "最终FRPNAME: $FRPNAME"

uci set frpc.common.server_addr='frp.jcmeng.top'
uci set frpc.common.server_port='40101'
uci set frpc.common.token='frp2026+-*.'
uci set frpc.common.tls_enable='false'

uci set frpc.common.admin_addr='127.0.0.1'
uci set frpc.common.admin_port='19698'
uci set frpc.common.admin_user='frpc'
uci set frpc.common.admin_pwd='1234qwer+-'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_luci"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='80'
uci set frpc.@conf[-1].remote_port='0'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_clash"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='9090'
uci set frpc.@conf[-1].remote_port='0'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_frpweb"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='19698'
uci set frpc.@conf[-1].remote_port='0'

uci commit
/etc/init.d/frpc restart


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
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/25.12.2/targets/mediatek/filogic/kmods/6.12.74-1-60d938adcb727697d3015e4285d4c290/packages.adb' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.pku.edu.cn/openwrt/releases/25.12.2/targets/mediatek/filogic/packages/packages.adb' /etc/apk/repositories.d/distfeeds.list

#sed -i 's/https/http/g' /etc/opkg/distfeeds.conf


# wifi设置
WIFINAME=$(ip link show br-lan 2>/dev/null | awk '/link\/ether/{split($2,m,":");print toupper(m[5]m[6])}')
uci set wireless.default_radio0.ssid=WiFi-${WIFINAME}-2.4G
uci set wireless.default_radio1.ssid=WiFi-${WIFINAME}-5G
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
