sed -i 's/192.168.6.1/10.3.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/10.3.2.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
mv $GITHUB_WORKSPACE/patch/padavanonly/199-diy.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
mv $GITHUB_WORKSPACE/patch/padavanonly/mtwifi.sh package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

#修改N60Pro闪存大小
sed -i 's/reg = <0x0580000 0x7280000>/reg = <0x0580000 0x1ea00000>/g' target/linux/mediatek/dts/mt7986a-netcore-n60-pro.dts

sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i "s/ImmortalWrt/OpenWrt/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#sed -i 's#mirrors.vsean.net/openwrt#mirror.nju.edu.cn/immortalwrt#g' package/emortal/default-settings/files/99-default-settings-chinese
mv $GITHUB_WORKSPACE/patch/banner package/base-files/files/etc/banner

#mkdir -p package/base-files/files/diy4me
#mv $GITHUB_WORKSPACE/patch/hanwckf/xy/socat package/base-files/files/diy4me/socat
#mv $GITHUB_WORKSPACE/patch/hanwckf/xy/zerotier package/base-files/files/diy4me/zerotier
#mv $GITHUB_WORKSPACE/patch/padavanonly/199-diy-wifi.sh package/base-files/files/etc/uci-defaults/zz-diy.sh
#chmod +x package/base-files/files/etc/uci-defaults/zz-diy.sh
#mv $GITHUB_WORKSPACE/patch/hanwckf/passwall/rules-pw2 package/base-files/files/diy4me/rules-pw2
# sed -i 's/0x580000 0x7280000/0x580000 0x1cc00000/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-netcore-n60-pro.dts

mv $GITHUB_WORKSPACE/patch/padavanonly/libxcrypt-Makefile feeds/packages/libs/libxcrypt/Makefile
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release
# mv $GITHUB_WORKSPACE/patch/padavanonly/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

if grep -q "openclash=y" "$GITHUB_WORKSPACE/$CONFIG_FILE"; then
    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    # Download clash_meta
    META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
    wget -qO- $META_URL | tar xOvz > files/etc/openclash/core/clash_meta
    chmod +x files/etc/openclash/core/clash_meta
    # 下载 GeoIP 和 GeoSite
    # wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O files/etc/openclash/GeoIP.dat
    # wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O files/etc/openclash/GeoSite.dat
else
    echo "⚪️ 未选择 luci-app-openclash"
fi
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
git clone --depth 1 https://github.com/vernesong/OpenClash.git package/OpenClash
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2.git package/passwall2
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-openclash}
rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

#git clone --depth 1 -b main https://github.com/kiddin9/kwrt-packages.git package/kwrt-pkg
#mv package/kwrt-pkg/luci-app-passwall package/luci-app-passwall
#mv package/kwrt-pkg/luci-app-passwall2 package/luci-app-passwall2
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-arpbind/Makefile
#rm -rf package/kwrt-pkg

#git clone --depth 1 https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
git clone --depth 1 https://github.com/AutoCONFIG/luci-app-rustdesk-server.git package/luci-app-rustdesk-server
git clone --depth 1 https://github.com/sirpdboy/netspeedtest.git package/luci-app-netspeedtest
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
git clone --depth 1 https://github.com/AngelaCooljx/luci-theme-material3.git package/luci-theme-material3

rm -rf feeds/packages/net/{adguardhome,alist,tailscale}
git clone --depth 1 https://github.com/kenzok8/small-package.git package/small-package
mv package/small-package/adguardhome feeds/packages/net/adguardhome
mv package/small-package/luci-app-adguardhome package/luci-app-adguardhome
mv package/small-package/luci-app-clouddrive2 package/luci-app-clouddrive2
mv package/small-package/luci-app-guest-wifi package/luci-app-guest-wifi
mv package/small-package/luci-app-ikoolproxy package/luci-app-ikoolproxy
#mv package/small-package/tailscale package/tailscale
mv package/small-package/luci-app-tailscale package/luci-app-tailscale
mv package/small-package/wrtbwmon package/wrtbwmon
mv package/small-package/luci-app-wrtbwmon package/luci-app-wrtbwmon
rm -rf package/small-package

# iStore
git clone --depth 1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth 1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth 1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

#git clone --depth 1 -b openwrt-21.02 https://github.com/immortalwrt/luci.git package/imm21-luci
#mv package/imm21-luci/applications/luci-app-accesscontrol package/luci-app-accesscontrol
#mv package/imm21-luci/applications/luci-app-filetransfer package/luci-app-filetransfer
#mv package/imm21-luci/applications/luci-app-v2ray-server package/luci-app-v2ray-server
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-accesscontrol/Makefile
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-filetransfer/Makefile
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-v2ray-server/Makefile
#rm -rf package/imm21-luci
#git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/luci.git package/imm23-luci
#mv package/imm23-luci/applications/luci-app-accesscontrol package/luci-app-accesscontrol
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-accesscontrol/Makefile
#rm -rf package/imm23-luci


#git clone --depth 1 -b master https://github.com/coolsnowwolf/luci.git package/lean-luci
#mv package/lean-luci/applications/luci-app-arpbind package/luci-app-arpbind
#sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-arpbind/Makefile
#rm -rf package/lean-luci

## 修改DTS的ubi为490MB的0x1ea00000
#sed -i 's/reg = <0x600000 0x6e00000>/reg = <0x600000 0x1ea00000>/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
## 修改DTS的spi_nand的spi-max-frequency为52MHz，52000000
#sed -i 's/spi-max-frequency = <20000000>/spi-max-frequency = <52000000>/' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
#sed -i 's/reg = <0x600000 0x6e00000>/reg = <0x600000 0x1ea00000>/' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
#sed -E '/^DEVICE_PACKAGES/ s/(\s*)([^ ]*ksmbd[^ ]*)(\s*)/ /g; s/  +/ /g; s/ $//' target/linux/mediatek/image/mt7981.mk
#sed -i 's/luci-app-ksmbd luci-i18n-ksmbd-zh-cn ksmbd-utils/kmod-usb-storage-extras/g' target/linux/mediatek/image/mt7981.mk
#sed -i 's/luci-app-usb-printer luci-i18n-usb-printer-zh-cn/kmod-usb-storage/g' target/linux/mediatek/image/mt7981.mk
