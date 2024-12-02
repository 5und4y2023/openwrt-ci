sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.7.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
sed -i 's/OpenWrt/AX3000Pro/g' package/base-files/files/bin/config_generate

mv $GITHUB_WORKSPACE/patch/openwrt23.05/clt/mac80211.sh $OPENWRT_PATH/package/kernel/mac80211/files/lib/wifi/mac80211.sh
mv $GITHUB_WORKSPACE/patch/openwrt23.05/clt/10_system.js $OPENWRT_PATH/feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
mv $GITHUB_WORKSPACE/patch/openwrt23.05/clt/argon/bg1.jpg $OPENWRT_PATH/feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
mv $GITHUB_WORKSPACE/patch/openwrt23.05/clt/60_clt $OPENWRT_PATH/package/base-files/files/etc/uci-defaults/60_clt

git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/Siha06/my-openwrt-packages.git package/my-openwrt-packages

git clone --depth=1 -b openwrt-23.05 https://github.com/coolsnowwolf/luci.git package/lean-luci23
mv package/lean-luci23/applications/luci-app-accesscontrol feeds/luci/applications/luci-app-accesscontrol
mv package/lean-luci23/applications/luci-app-autoreboot feeds/luci/applications/luci-app-autoreboot
rm -rf package/lean-luci23