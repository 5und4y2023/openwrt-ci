sed -i 's/192.168.1.1/10.3.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/10.3.2.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.3.2.1/g' package/base-files/luci/bin/config_generate
sed -i 's/LEDE/OpenWrt/g' package/base-files/luci/bin/config_generate
sed -i 's/LEDE/OpenWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
mv $GITHUB_WORKSPACE/patch/banner package/base-files/files/etc/banner
sed -i '/openwrt_release/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/shadow/d' package/lean/default-settings/files/zzz-default-settings
sed -i 's#mirrors.tencent.com/lede#mirrors.pku.edu.cn/immortalwrt#g' package/lean/default-settings/files/zzz-default-settings

mv $GITHUB_WORKSPACE/patch/lean/199-diy.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
# sed -i 's/0x0580000 0x7280000/0x580000 0x1cc00000/g' target/linux/mediatek/dts/mt7986a-netcore-n60-pro.dts

rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git  package/luci-app-argon-config
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon


# mv $GITHUB_WORKSPACE/patch/QINGYIN/QINGYINSSIDMAC1.sh package/base-files/files/etc/init.d/QINGYINSSIDMAC1.sh
# mv $GITHUB_WORKSPACE/patch/QINGYIN/lede-10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

find ./ | grep Makefile | grep oaf | xargs rm -f
rm -rf feeds/packages/net/open-app-filter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git  package/oaf
git clone --depth 1 https://github.com/sirpdboy/luci-app-parentcontrol package/luci-app-parentcontrol
git clone --depth 1 https://github.com/lwb1978/openwrt-gecoosac.git package/openwrt-gecoosac
git clone --depth 1 https://github.com/sbwml/luci-app-mentohust package/mentohust


rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
rm -rf feeds/luci/applications/{luci-app-openclash,luci-app-passwall,luci-app-passwall2,luci-app-mosdns}
git clone --depth 1 https://github.com/vernesong/OpenClash.git  package/openclash
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/luci-app-passwall
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2.git package/luci-app-passwall2
#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# iStore
git clone --depth 1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth 1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth 1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

rm -rf feeds/packages/net/{adguardhome,alist,lucky,tailscale}
rm -rf feeds/luci/applications/{luci-app-adguardhome,luci-app-alist,luci-app-lucky,luci-app-tailscale}
git clone --depth 1 https://github.com/kenzok8/small-package.git package/kz8-small
mv package/kz8-small/adguardhome package/adguardhome
mv package/kz8-small/luci-app-adguardhome package/luci-app-adguardhome
mv package/kz8-small/lucky package/lucky
mv package/kz8-small/luci-app-lucky package/luci-app-lucky
mv package/kz8-small/luci-app-wrtbwmon package/luci-app-wrtbwmon
mv package/kz8-small/wrtbwmon package/wrtbwmon
mv package/kz8-small/luci-app-tailscale package/luci-app-tailscale
mv package/kz8-small/tailscale package/tailscale
rm -rf package/kz8-small


#git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/packages package/imm23pkg
#mv package/imm23pkg/net/mentohust package/mentohust
#rm -rf package/imm23pkg

#rm -rf feeds/luci/applications/luci-app-mentohust
#git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/luci package/imm23luci
#mv package/imm23luci/applications/luci-app-mentohust package/luci-app-mentohust
#rm -rf package/imm23luci


