#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci commit

#cat /diy4me/rules-pw2 >> /etc/config/passwall2
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -i '/Modem/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
sed -i '/filogic/d' /etc/opkg/distfeeds.conf
#echo > /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_core https://mirrors.pku.edu.cn/immortalwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_kmods https://mirrors.pku.edu.cn/immortalwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/kmods/6.6.95-1-3ca4b8cb2fcc3a2027e8496143a86cab' /etc/opkg/distfeeds.conf
echo > /etc/opkg/customfeeds.conf
sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/packages-24.10/aarch64_generic/kiddin9' /etc/opkg/customfeeds.conf
#sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

uci del network.wan6
uci del network.lan.ip6assign
uci del network.globals.ula_prefix
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci del dhcp.lan.ra

#uci set wireless.default_MT7981_1_1.ssid=xiaoguo
#uci set wireless.default_MT7981_1_1.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_1.key=12345678
#uci set wireless.default_MT7981_1_2.ssid=TK888
#uci set wireless.default_MT7981_1_2.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_2.key=12345678
#uci commit wireless

uci set wireless.MT7986_1_2.htmode='HE80'
uci set wireless.MT7986_1_2.channel='44'
uci set wireless.default_MT7986_1_1.encryption=psk2+ccmp
uci set wireless.default_MT7986_1_1.key=password
uci set wireless.default_MT7986_1_2.encryption=psk2+ccmp
uci set wireless.default_MT7986_1_2.key=password
# 路由器cpu芯片
router_cpu=MT7981

# 新增WiFi数量
increase_wifi_num=6

# 除去默认，原本有几个WiFi
existed_wifi_num=0

# WiFi名称
ssid=RAX3000M

# WiFi密码
password=password

# WiFi地址
ipaddr=10.10.1.1

############################### 分 割 线 ###################################

routermac=$(cat /sys/class/net/br-lan/address 2>/dev/null | awk -F: '{print $5 $6}' | tr 'a-z' 'A-Z')
a=$(echo "$ipaddr" | awk -F. '{print $1}')
b=$(echo "$ipaddr" | awk -F. '{print $2}')
c=$(echo "$ipaddr" | awk -F. '{print $3}')
d=$(echo "$ipaddr" | awk -F. '{print $4}')

total_wifi=$((increase_wifi_num + existed_wifi_num))
# 生成配置
for i in $(seq $((existed_wifi_num + 1)) $total_wifi); do
    wifinet_num=$((i + 1))
    new_c=$((c + i - 1))
    new_ipaddr="${a}.${b}.${new_c}.${d}"

    # 格式化接口编号为两位数
    wifi_id=$(printf "%02d" $i)

    # 根据序号选择wireless设备
    if [ $i -le 15 ]; then
        wireless_dev="${router_cpu}_1_2"
        network_dev="rax${i}"
    else
        wireless_dev="${router_cpu}_1_1"
        network_dev="ra$((i - 15))"
    fi

    # 配置无线接口
    uci set wireless.wifinet${wifinet_num}=wifi-iface
    uci set wireless.wifinet${wifinet_num}.device="$wireless_dev"
    uci set wireless.wifinet${wifinet_num}.mode='ap'
    uci set wireless.wifinet${wifinet_num}.ssid="${ssid}-${wifi_id}"
    uci set wireless.wifinet${wifinet_num}.encryption='psk2+ccmp'
    uci set wireless.wifinet${wifinet_num}.key="$password"
    uci set wireless.wifinet${wifinet_num}.network="wifi${wifi_id}"

    # 配置网络接口
    uci set network.wifi${wifi_id}=interface
    uci set network.wifi${wifi_id}.proto='static'
    uci set network.wifi${wifi_id}.device="${network_dev}"
    uci set network.wifi${wifi_id}.ipaddr="$new_ipaddr"
    uci set network.wifi${wifi_id}.netmask='255.255.255.0'

    # 配置DHCP
    uci set dhcp.wifi${wifi_id}=dhcp
    uci set dhcp.wifi${wifi_id}.interface="wifi${wifi_id}"

    # 配置防火墙
    uci add firewall zone
    uci set firewall.@zone[-1].name="wifi${wifi_id}"
    uci set firewall.@zone[-1].input='ACCEPT'
    uci set firewall.@zone[-1].output='ACCEPT'
    uci set firewall.@zone[-1].forward='ACCEPT'
    uci add_list firewall.@zone[-1].network="wifi${wifi_id}"

    uci add firewall forwarding
    uci set firewall.@forwarding[-1].src="wifi${wifi_id}"
    uci set firewall.@forwarding[-1].dest='wan'

done

# 提交配置
uci commit wireless
uci commit network
uci commit dhcp
uci commit firewall

# 重启服务
echo -e "\n配置已完成！"
/etc/init.d/network restart >/dev/null 2>&1
/etc/init.d/firewall restart >/dev/null 2>&1
/etc/init.d/dnsmasq restart >/dev/null 2>&1
/etc/init.d/dropbear restart >/dev/null 2>&1


exit 0
