sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.5.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

sed -i 's//FanchmWrt/cookie/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/cookie/g' package/base-files/files/bin/config_generate
#sed -i 's/ImmortalWrt/OpenWrt/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
#sed -i 's/ImmortalWrt/OpenWrt/g' include/version.mk
mv $GITHUB_WORKSPACE/patch/immortalwrt-24.10/199-mt798x.sh package/base-files/files/etc/uci-defaults/zz-111diy.sh
#mv $GITHUB_WORKSPACE/patch/tiktok/open-32wifi.sh package/base-files/files/etc/uci-defaults/zz-222wifi.sh

#mkdir -p package/base-files/files/root
#mv $GITHUB_WORKSPACE/patch/tiktok/open-32wifi.sh package/base-files/files/root/open-wifi.sh
#mv $GITHUB_WORKSPACE/patch/tiktok/kwrt-luci-app-frpc.ipk package/base-files/files/root/kwrt-luci-app-frpc.ipk
#mv $GITHUB_WORKSPACE/patch/tiktok/imm24-10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#mv $GITHUB_WORKSPACE/patch/tiktok/tk12318-bgp.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
#mv $GITHUB_WORKSPACE/patch/tiktok/imm24-mac80211.uc package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
#mv $GITHUB_WORKSPACE/patch/tiktok/199-diy.sh package/base-files/files/etc/uci-defaults/zzz-diy.sh

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


#tr3000大分区112m
sed -i 's/0x4000000/0x7000000/g' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dts
#大分区512m
# sed -i 's/0x4000000/0x1ea00000/g' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dts
# sed -i 's/0x0580000 0x7a80000/0x580000 0x1cc00000/g' target/linux/mediatek/dts/mt7986a-netcore-n60-pro.dts

#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release

# iStore
git clone --depth=1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth=1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-openclash}
rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
git clone --depth 1 https://github.com/vernesong/OpenClash.git package/OpenClash
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns


find ./ | grep Makefile | grep oaf | xargs rm -f
rm -rf feeds/packages/net/open-app-filter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth 1 https://github.com/sirpdboy/luci-app-parentcontrol package/luci-app-parentcontrol
git clone --depth 1 https://github.com/lwb1978/openwrt-gecoosac.git package/openwrt-gecoosac
git clone --depth 1 https://github.com/sirpdboy/luci-app-eqosplus.git package/luci-app-eqosplus
git clone --depth 1 -b js https://github.com/sirpdboy/luci-app-netspeedtest.git package/luci-app-netspeedtest

rm -rf feeds/packages/net/{adguardhome,tailscale}
git clone --depth=1 https://github.com/kenzok8/small-package.git package/kz8-small
mv package/kz8-small/adguardhome package/adguardhome
mv package/kz8-small/luci-app-adguardhome package/luci-app-adguardhome
mv package/kz8-small/luci-app-wrtbwmon package/luci-app-wrtbwmon
mv package/kz8-small/wrtbwmon package/wrtbwmon
mv package/kz8-small/homebox package/homebox
mv package/kz8-small/luci-app-poweroffdevice package/luci-app-poweroffdevice
mv package/kz8-small/tailscale package/tailscale
mv package/kz8-small/luci-app-tailscale package/luci-app-tailscale
mv package/kz8-small/luci-app-socat package/luci-app-socat
rm -rf package/kz8-small

#修复TailScale配置文件冲突
sed -i '/\/files/d'  package/tailscale/Makefile
#修复rust
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile
