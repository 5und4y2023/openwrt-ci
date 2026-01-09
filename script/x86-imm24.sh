#添加TurboAcc
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i 's/192.168.1.1/192.168.86.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.86.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
#sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
#sed -i 's/ImmortalWrt/OpenWrt/g' include/version.mk
sed -i 's/ImmortalWrt/WiFi/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
# sed -i 's#mirrors.vsean.net/openwrt#mirrors.pku.edu.cn/immortalwrt#g' package/emortal/default-settings/files/99-default-settings-chinese
#mv $GITHUB_WORKSPACE/patch/banner $OPENWRT_PATH/package/base-files/files/etc/banner
mv $GITHUB_WORKSPACE/patch/immortalwrt-24.10/199-x86-1.sh package/base-files/files/etc/uci-defaults/zz-diy.sh

if grep -q "openclash=y" "$GITHUB_WORKSPACE/$CONFIG_FILE"; then
    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    # Download clash_meta
    META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"
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

#下载5g模块
#git clone --depth 1 https://github.com/Siriling/5G-Modem-Support.git package/5g-modem

# iStore
git clone --depth=1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth=1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-openclash}
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

git clone --depth 1 https://github.com/vernesong/OpenClash.git package/OpenClash
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo.git package/OpenWrt-momo
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2
git clone --depth 1 https://github.com/Thaolga/openwrt-nekobox.git package/luci-app-nekobox
#rm -rf feeds/packages/devel/gn

git clone --depth 1 https://github.com/sbwml/luci-app-openlist2.git package/openlist2
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth 1 https://github.com/ilxp/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
git clone --depth 1 https://github.com/sirpdboy/luci-app-eqosplus.git package/luci-app-eqosplus
git clone --depth 1 https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
git clone --depth 1 -b js https://github.com/sirpdboy/luci-app-netspeedtest.git package/luci-app-netspeedtest

rm -rf feeds/packages/net/{adguardhome,tailscale}
git clone --depth 1 https://github.com/kenzok8/small-package.git package/kz8-small
mv package/kz8-small/adguardhome package/adguardhome
mv package/kz8-small/luci-app-adguardhome package/luci-app-adguardhome
mv package/kz8-small/luci-app-ap-modem package/luci-app-ap-modem
mv package/kz8-small/lucky package/lucky
mv package/kz8-small/luci-app-lucky package/luci-app-lucky
mv package/kz8-small/luci-app-kodexplorer package/luci-app-kodexplorer
mv package/kz8-small/luci-app-wrtbwmon package/luci-app-wrtbwmon
mv package/kz8-small/wrtbwmon package/wrtbwmon
mv package/kz8-small/luci-app-poweroff package/luci-app-poweroff
mv package/kz8-small/luci-app-socat package/luci-app-socat
mv package/kz8-small/luci-app-tailscale package/luci-app-tailscale
mv package/kz8-small/tailscale package/tailscale
rm -rf package/kz8-small

#修复TailScale配置文件冲突
sed -i '/\/files/d'  package/tailscale/Makefile
#修复rust
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/luci package/imm23luci
# mv package/imm23luci/applications/luci-app-adbyby-plus package/luci-app-adbyby-plus
# rm -rf package/imm23luci
# git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/packages package/imm23packages
# mv package/imm23packages/net/adbyby package/adbyby
# rm -rf package/imm23packages
# sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-adbyby-plus/Makefile
