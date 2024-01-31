#!/bin/bash
clear

### 基础部分 ###
# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk
# 更新 Feeds
sed -i '1i src-git mini https://github.com/r1172464137/openwrt_package.git;mini' feeds.conf.default
sed -i '2i src-git theme https://github.com/r1172464137/openwrt_package.git;themejs' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a

mkdir -p files/usr/share/dae
mkdir -p package/base-files/files/usr/bin
curl -o files/usr/share/dae/geoip.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
curl -o files/usr/share/dae/geosite.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat

curl -o package/base-files/files/usr/bin/fuck https://raw.githubusercontent.com/msylgj/R2S-R4S-OpenWrt/master/SCRIPTS/fuck

sed -i "s/'%D %V %C'/'Built by Coupile($(date +%Y.%m.%d))@%D %V'/g" package/base-files/files/etc/openwrt_release
# sed -i "/DISTRIB_REVISION/d" package/base-files/files/etc/openwrt_release
# sed -i "/%D/a\ Built by Coupile($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i "s,hostname='ImmortalWrt',hostname='OpenWrt',g" package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt -b packages-23.05 feeds/packages/lang/node

rm -rf package/emortal/daed-next
git clone -b rebase --depth 1 https://github.com/QiuSimons/luci-app-daed-next package/emortal/daed-next
find ./package/emortal/daed-next/luci-app-daed-next/root/etc -type f -exec chmod +x {} \;


# 清理可能因patch存在的冲突文件
find ./ -name *.orig | xargs rm -rf
find ./ -name *.rej | xargs rm -rf

exit 0
