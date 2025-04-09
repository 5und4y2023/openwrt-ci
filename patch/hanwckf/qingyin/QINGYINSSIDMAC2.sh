#!/bin/bash /etc/rc.common
START=00

start() {
    chmod +x /lib/qingyin.sh
    /lib/qingyin.sh start
    array=("ZTE" "TP-Link" "Tenda" "Xiaomi" "ChinaNet" "360WiFi" "CMCC" "H3C" "ASUS" "CN" "Cisco" "MERCURY" "TOTOLINK" "Netgear" "rujie" "TP" "UBNT" "honor" "FAST" "CU" "HUAWEI" "Netcore" "LINKSYS" "Phicomm" "AFR" "D-Link")
    array_length=${#array[@]}
    index=$((RANDOM % array_length))
    random_string=${array[$index]}
    NEW_SSID5G1="${random_string}01_$(tr -dc 'A-F0-9' < /dev/urandom | head -c 6)_5G"
    index=$((RANDOM % array_length))
    random_string=${array[$index]}
    NEW_SSID5G2="${random_string}27_$(tr -dc 'A-F0-9' < /dev/urandom | head -c 6)"
    index=$((RANDOM % array_length))
    random_string=${array[$index]}
    NEW_SSID5G3="${random_string}28_$(tr -dc 'A-F0-9' < /dev/urandom | head -c 6)"
    index=$((RANDOM % array_length))
    random_string=${array[$index]}
    NEW_SSID5G4="${random_string}29_$(tr -dc 'A-F0-9' < /dev/urandom | head -c 6)"
    index=$((RANDOM % array_length))
    random_string=${array[$index]}
    NEW_SSID5G5="${random_string}30_$(tr -dc 'A-F0-9' < /dev/urandom | head -c 6)"
    # NEW_SSID24G="ZTE_$(cat /proc/sys/kernel/random/uuid | cut -c 25-)_30-2.4G"

    # ������ָ��WiFi˳������
    uci set wireless.@wifi-iface[0].ssid="$NEW_SSID5G1"
    # uci set wireless.@wifi-iface[0].ssid="$NEW_SSID24G"
    uci set wireless.@wifi-iface[1].ssid="$NEW_SSID5G1"
    uci set wireless.@wifi-iface[2].ssid="$NEW_SSID5G2"
    uci set wireless.@wifi-iface[3].ssid="$NEW_SSID5G3"
    uci set wireless.@wifi-iface[4].ssid="$NEW_SSID5G4"
    uci set wireless.@wifi-iface[5].ssid="$NEW_SSID5G5"
    # ����:���ô洢���Ʒ�ֹ�Զ���ԭ
    uci commit wireless
    # ����:����SH���񼴿���Ч��
    # /etc/init.d/network restart
    reboot
    # ����:��������!!!
    # ����:��������!!!
    # ����:��������!!!
    # ����:���ϴ����������޸ģ���˽���޸ĵ���u-boot��ʧ��·�ɱ�ש�Ų�����!!!
    # ����:���ϴ����������޸ģ���˽���޸ĵ���u-boot��ʧ��·�ɱ�ש�Ų�����!!!
    # ����:���ϴ����������޸ģ���˽���޸ĵ���u-boot��ʧ��·�ɱ�ש�Ų�����!!!
}