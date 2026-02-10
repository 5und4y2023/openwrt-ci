sed -i 's/192.168.1.1/10.3.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/10.3.2.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
mv $GITHUB_WORKSPACE/patch/hanwckf/199-diy-mini.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
#sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
#sed -i "s/ImmortalWrt/OpenWrt/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#mv $GITHUB_WORKSPACE/patch/banner package/base-files/files/etc/banner
# mv $GITHUB_WORKSPACE/patch/hanwckf/mt7986a-netcore-n60pro.dts target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-netcore-n60.dts

#mv $GITHUB_WORKSPACE/patch/hanwckf/mtwifi.sh package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#mv $GITHUB_WORKSPACE/patch/hanwckf/mk/modules-netfilter.mk package/kernel/linux/modules/netfilter.mk
#mv $GITHUB_WORKSPACE/patch/hanwckf/mk/include-netfilter.mk include/netfilter.mk

#mkdir -p package/base-files/files/diy4me
#mv $GITHUB_WORKSPACE/patch/hanwckf/passwall/mt798x-30wifi-closed.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
#chmod +x package/base-files/files/etc/uci-defaults/zz-diy.sh
#mv $GITHUB_WORKSPACE/patch/hanwckf/passwall/rules-pw2 package/base-files/files/diy4me/rules-pw2
#mv $GITHUB_WORKSPACE/patch/hanwckf/xy/socat package/base-files/files/diy4me/socat
#mv $GITHUB_WORKSPACE/patch/hanwckf/xy/zerotier package/base-files/files/diy4me/zerotier


if grep -q "openclash=y" "$GITHUB_WORKSPACE/$CONFIG_FILE"; then
    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    # Download clash_meta
    META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
    wget -qO- $META_URL | tar xOz > files/etc/openclash/core/clash_meta
    chmod +x files/etc/openclash/core/clash_meta
    # Download GeoIP and GeoSite
    # wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O files/etc/openclash/GeoIP.dat
    # wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O files/etc/openclash/GeoSite.dat
else
    echo "⚪️ 未选择 luci-app-openclash"
fi

#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release
#mv $GITHUB_WORKSPACE/patch/hanwckf/xm-10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#定制版补丁
#mv $GITHUB_WORKSPACE/patch/tiktok/hanwckf-mtwifi.sh package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#mv $GITHUB_WORKSPACE/patch/tiktok/1-bgp.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
#mv $GITHUB_WORKSPACE/patch/tiktok/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#改大闪存
sed -i 's/reg = <0x600000 0x6e00000>/reg = <0x600000 0x1ea00000>/' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
#sed -i 's/<0x580000 0x7200000>/<0x580000 0xee00000>/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dts
#sed -i 's/116736k/240128k/g' target/linux/mediatek/image/mt7981.mk


# 添加kenzok8_small插件库, 编译新版Sing-box和hysteria，需golang版本1.20或者以上版本 ，可以用以下命令
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
rm -rf feeds/luci/applications/{luci-app-openclash,luci-app-passwall,luci-app-ssr-plus,luci-app-mosdns}
#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/vernesong/OpenClash.git  package/openclash
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/luci-app-passwall
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2.git package/luci-app-passwall2

git clone --depth 1 https://github.com/sbwml/luci-app-openlist2 package/openlist
#git clone --depth 1 https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
#git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/oaf
#git clone --depth 1 https://github.com/sirpdboy/luci-app-netspeedtest.git package/luci-app-netspeedtest
# iStore官方
git clone --depth=1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth=1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network


rm -rf feeds/packages/net/{adguardhome,smartdns,tailscale}
rm -rf feeds/luci/applications/{luci-app-alist,luci-app-smartdns}
git clone --depth 1 https://github.com/kenzok8/small-package.git package/small-package
mv package/small-package/luci-app-adguardhome package/luci-app-adguardhome
mv package/small-package/adguardhome feeds/packages/net/adguardhome
mv package/small-package/luci-app-easymesh package/luci-app-easymesh
mv package/small-package/luci-app-easytier package/luci-app-easytier
mv package/small-package/luci-app-gecoosac package/luci-app-gecoosac
mv package/small-package/luci-app-smartdns package/luci-app-tailscale
mv package/small-package/smartdns feeds/packages/net/tailscale
mv package/small-package/luci-app-ikoolproxy package/luci-app-ikoolproxy
mv package/small-package/wrtbwmon package/wrtbwmon
mv package/small-package/luci-app-wrtbwmon package/luci-app-wrtbwmon
mv package/small-package/lucky package/lucky
mv package/small-package/luci-app-lucky package/luci-app-lucky

rm -rf package/small-package

rm -rf feeds/packages/net/frp
git clone --depth 1 -b openwrt-24.10 https://github.com/immortalwrt/packages package/imm24pkg
mv package/imm24pkg/net/frp feeds/packages/net/frp
rm -rf package/imm24pkg

#rm -rf feeds/luci/applications/luci-app-frpc
#git clone --depth 1 -b openwrt-24.10 https://github.com/immortalwrt/luci package/imm24luci
#mv package/imm24luci/applications/luci-app-frpc package/luci-app-frpc
#rm -rf package/imm24luci

#git clone --depth 1 https://github.com/coolsnowwolf/lede.git package/lede
#mv package/lede/package/lean/luci-app-leigod-acc package/luci-app-leigod-acc
#mv package/lede/package/lean/leigod-acc package/leigod-acc
#rm -rf package/lede
