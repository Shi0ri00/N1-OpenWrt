#!/bin/bash

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Default IP
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate

rm -rf package/custom; mkdir -p package/custom

# Remove packages
rm -rf feeds/luci/applications/luci-app-passwall

# Add packages
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git clone --depth=1 https://github.com/vernesong/OpenClash OpenClash/luci-app-openclash
git clone --depth=1 https://github.com/morytyann/OpenWrt-mihomo package/custom
#argon theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon


./scripts/feeds update -a
./scripts/feeds install -a
