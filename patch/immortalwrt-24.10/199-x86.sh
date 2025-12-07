#!/bin/sh

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


#uci set dhcp.lan.ignore='1'
#uci set network.lan.ipaddr='192.168.31.3'
#uci commit dhcp
#uci commit network
#uci commit
#/etc/init.d/network restart
#/etc/init.d/odhcpd restart

exit 0
