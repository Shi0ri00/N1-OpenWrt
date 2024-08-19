#!/bin/bash

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Default IP
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    # find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}

rm -rf package/custom; mkdir package/custom

# Remove packages
rm -rf feeds/luci/applications/luci-app-passwall

# Add packages
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
merge_package https://github.com/morytyann/OpenWrt-mihomo Openwrt-mihomo

#argon theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon


./scripts/feeds update -a
./scripts/feeds install -a
