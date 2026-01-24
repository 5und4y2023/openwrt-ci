#添加TurboAcc
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i 's/192.168.1.1/10.3.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/10.3.2.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
mv $GITHUB_WORKSPACE/patch/openwrt-24.10/199-mt798x.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
sed -i 's/${defaults ? 0 : 1}/0/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

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
#sed -i 's/0x4000000/0x7000000/g' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dts

#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release


# iStore
git clone --depth 1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth 1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth 1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

#git clone --depth 1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth 1 https://github.com/vernesong/OpenClash.git package/OpenClash
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2.git package/passwall2
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-openclash}

git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth 1 https://github.com/sirpdboy/luci-app-eqosplus.git package/luci-app-eqosplus


#修复TailScale配置文件冲突
sed -i '/\/files/d'  package/tailscale/Makefile
#修复rust
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile
#git clone --depth 1 -b openwrt-21.02 https://github.com/immortalwrt/luci.git package/imm21-luci
#mv package/imm21-luci/applications/luci-app-filetransfer package/luci-app-filetransfer
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-accesscontrol/Makefile
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-filetransfer/Makefile
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-v2ray-server/Makefile
#mv package/imm21-luci/libs/luci-lib-fs package/luci-lib-fs
#rm -rf package/imm21-luci
