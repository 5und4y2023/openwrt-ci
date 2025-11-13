#!/bin/sh


# 新增WiFi数量
increase_wifi_num=32
# 除去默认，原本有几个WiFi
existed_wifi_num=0

# WiFi名称
ssid=WiFi

# WiFi密码
password=123123123

# WiFi接口地址
ipaddr=10.10.101.1

# 是否保留默认WiFi
keep_default_wifi=no
uci del wireless.default_radio0
uci del wireless.default_radio1

# 单频WiFi芯片支持的最大WiFi数量
# mt798x系列为16，ipq系列为8
max_wifi_num=16
############################### 分 割 线 ###################################

routermac=$(cat /sys/class/net/br-lan/address 2>/dev/null | awk -F: '{print $5 $6}' | tr 'a-z' 'A-Z')
a=$(echo "$ipaddr" | awk -F. '{print $1}')
b=$(echo "$ipaddr" | awk -F. '{print $2}')
c=$(echo "$ipaddr" | awk -F. '{print $3}')
d=$(echo "$ipaddr" | awk -F. '{print $4}')

# 判断是否保留默认WiFi
if [ "$keep_default_wifi" = "yes" ]; then
    final_max_wifi_num=$((max_wifi_num - 1))
else
    final_max_wifi_num=${max_wifi_num}
fi

# 判断新增WiFi数量是否超过了无线芯片的限制
total_wifi=$((increase_wifi_num + existed_wifi_num))
if [ $total_wifi -gt $((final_max_wifi_num + final_max_wifi_num)) ]; then
    echo "WiFi数量超过了无线芯片限制，请重新设置"
    exit 1 
fi

# 生成配置
for i in $(seq $((existed_wifi_num + 1)) $total_wifi); do
    if [ "$keep_default_wifi" = "yes" ]; then
        wifinet_num=$((i + 1))
    else
        wifinet_num=$((i - 1))
    fi
    new_c=$((c + i -1))
	ipaddr="${a}.${b}.${new_c}.${d}"

    # 格式化接口编号为两位数
    wifi_id=$(printf "%02d" $i)

    # 根据序号选择wireless设备
    if [ $i -le $final_max_wifi_num ]; then
        wireless_dev="radio1"
		network_dev="5GAP"
    else
        wireless_dev="radio0"
		network_dev="2.4GAP"
    fi

    # 配置无线接口
    uci set wireless.wifinet${wifinet_num}=wifi-iface
    uci set wireless.wifinet${wifinet_num}.device="$wireless_dev"
    uci set wireless.wifinet${wifinet_num}.mode='ap'
    uci set wireless.wifinet${wifinet_num}.ssid="${wifi_id}"
    uci set wireless.wifinet${wifinet_num}.encryption='psk2+ccmp'
    uci set wireless.wifinet${wifinet_num}.key="$password"
    uci set wireless.wifinet${wifinet_num}.ifname="${network_dev}${wifi_id}"
    uci set wireless.wifinet${wifinet_num}.network="wifi${wifi_id}"

    # 配置网络接口
    uci set network.wifi${wifi_id}=interface
    uci set network.wifi${wifi_id}.proto='static'
    uci set network.wifi${wifi_id}.device="${network_dev}${wifi_id}"
    uci set network.wifi${wifi_id}.ipaddr="$ipaddr"
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

    uci add firewall rule
    uci set firewall.@rule[-1].src="wifi${wifi_id}"
    uci set firewall.@rule[-1].dest='wan'
    uci set firewall.@rule[-1].name="wifi${wifi_id}"
    uci add_list firewall.@rule[-1].proto='all'
    uci set firewall.@rule[-1].target='REJECT'
done

# 提交配置
uci commit wireless
uci commit network
uci commit dhcp
uci commit firewall


# 重启服务
echo -e "\n配置已完成！"
echo "正在重启网络服务使配置生效，请等待几秒"
/etc/init.d/network restart >/dev/null 2>&1
/etc/init.d/firewall restart >/dev/null 2>&1
/etc/init.d/dnsmasq restart >/dev/null 2>&1
/etc/init.d/dropbear restart >/dev/null 2>&1
