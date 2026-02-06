sed -i 's/192.168.1.1/10.3.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/10.3.2.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/OpenWrt/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i 's/ImmortalWrt/OpenWrt/g' include/version.mk
mv $GITHUB_WORKSPACE/patch/banner package/base-files/files/etc/banner
mv $GITHUB_WORKSPACE/patch/hanwckf/199-diy-mini.sh package/base-files/files/etc/uci-defaults/zz-diy.sh

#改大闪存
sed -i 's/reg = <0x600000 0x6e00000>/reg = <0x600000 0x1ea00000>/' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#mv $GITHUB_WORKSPACE/patch/hanwckf/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release

#安装最新openclash
rm -rf feeds/luci/applications/luci-app-openclash
git clone --depth=1 https://github.com/vernesong/OpenClash.git  package/openclash
mv package/openclash/luci-app-openclash feeds/luci/applications/
rm -rf package/openclash

rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone --depth 1 https://github.com/5und4y2023/luci-app-ddns-go.git package/luci-app-ddns-go

# iStore官方
git clone --depth=1 -b main https://github.com/linkease/istore.git package/istore
git clone --depth=1 -b master https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci.git package/nas-luci
mv package/nas-packages/network/services/* package/nas-packages/
rm -rf package/nas-packages/network

#adguardhome，alist,frc,需要go版本需要最新的
# git clone --depth=1 https://github.com/mingxiaoyu/luci-app-phtunnel.git package/phtunnel
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
git clone --depth=1 https://github.com/kenzok8/small-package.git package/small-package
mv package/small-package/luci-app-adguardhome package/luci-app-adguardhome
mv package/small-package/luci-app-ikoolproxy package/luci-app-ikoolproxy
mv package/small-package/luci-app-easymesh package/luci-app-easymesh
mv package/small-package/luci-app-gecoosac package/luci-app-gecoosac
mv package/small-package/luci-app-ikoolproxy package/luci-app-ikoolproxy
rm -rf package/small-package

# git clone --depth 1 https://github.com/coolsnowwolf/lede.git package/lede
# mv package/lede/package/lean/luci-app-leigod-acc package/luci-app-leigod-acc
# mv package/lede/package/lean/leigod-acc package/leigod-acc
# rm -rf package/lede

#下载5g模块
# git clone --depth=1 https://github.com/Siriling/5G-Modem-Support.git package/5g-modem
#UA2F校园网
#git clone https://github.com/lucikap/luci-app-ua2f.git package/luci-app-ua2f
#git clone https://github.com/Zxilly/UA2F.git package/UA2F
#git clone https://github.com/EOYOHOO/UA2F.git package/UA2F
#git clone https://github.com/EOYOHOO/rkp-ipid.git package/rkp-ipid
#rm -rf feeds/packages/net/ua2f
