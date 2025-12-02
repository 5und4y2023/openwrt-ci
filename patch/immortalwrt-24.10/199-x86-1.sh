#!/bin/sh
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

#其他网络设置

uci commit

sed -i '/modem/d' /etc/opkg/distfeeds.conf
sed -i '/Modem/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
sed -i '/targets/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz kmods https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/x86/64/kmods/6.6.110-1-f8c5d7fde74fa4fedf4370775255c515' /etc/opkg/distfeeds.conf
sed -i '$a src/gz immortalwrt_core https://mirrors.pku.edu.cn/immortalwrt/releases/24.10.4/targets/x86/64/packages' /etc/opkg/distfeeds.conf

cp /etc/my-clash /etc/openclash/core/clash_meta


# 计算网卡数量
count=0
ifnames=""
for iface in /sys/class/net/*; do
  iface_name=$(basename "$iface")
  # 检查是否为物理网卡（排除回环设备和无线设备）
  if [ -e "$iface/device" ] && echo "$iface_name" | grep -Eq '^eth|^en'; then
    count=$((count + 1))
    ifnames="$ifnames $iface_name"
  fi
done
# 删除多余空格
ifnames=$(echo "$ifnames" | awk '{$1=$1};1')

# 网络设置
if [ "$count" -eq 1 ]; then
   # 单网口设备 类似于NAS模式 动态获取ip模式 具体ip地址取决于上一级路由器给它分配的ip 也方便后续你使用web页面设置旁路由
   # 单网口设备 不支持修改ip 不要在此处修改ip 
   uci set network.lan.proto='dhcp'
   uci set dhcp.lan.ignore='1'
elif [ "$count" -gt 1 ]; then
   # 提取第一个接口作为WAN
   wan_ifname=$(echo "$ifnames" | awk '{print $1}')
   # 剩余接口保留给LAN
   lan_ifnames=$(echo "$ifnames" | cut -d ' ' -f2-)
   # 设置WAN接口基础配置
   uci set network.wan=interface
   # 提取第一个接口作为WAN
   uci set network.wan.device="$wan_ifname"
   # WAN接口默认DHCP
   uci set network.wan.proto='dhcp'
   # 设置WAN6绑定网口eth0
   uci set network.wan6=interface
   uci set network.wan6.device="$wan_ifname"
   # 更新LAN接口成员
   # 查找对应设备的section名称
   section=$(uci show network | awk -F '[.=]' '/\.@?device\[\d+\]\.name=.br-lan.$/ {print $2; exit}')
   if [ -z "$section" ]; then
      echo "error：cannot find device 'br-lan'." >> $LOGFILE
   else
      # 删除原来的ports列表
      uci -q delete "network.$section.ports"
      # 添加新的ports列表
      for port in $lan_ifnames; do
         uci add_list "network.$section.ports"="$port"
      done
      echo "ports of device 'br-lan' are update." >> $LOGFILE
   fi
   # LAN口设置静态IP
   uci set network.lan.proto='static'
   # 多网口设备 支持修改为别的ip地址
   uci del dhcp.lan.ra_slaac
   uci del dhcp.lan.dhcpv6
   uci del dhcp.lan.ra_flags
   uci add_list dhcp.lan.ra_flags='none'
   uci set dhcp.lan.dns_service='0'
   uci del network.globals.packet_steering
   uci del network.globals.ula_prefix
   uci set network.lan.ip6assign='64'
   uci set network.lan.ip6ifaceid='eui64'

fi

uci commit dhcp
uci commit network
uci commit
/etc/init.d/network restart

exit 0
