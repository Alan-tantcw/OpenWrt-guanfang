#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/11.1.1.1/g' package/base-files/files/bin/config_generate
# 禁用ipv6
sed -i "/ip6assign='60'/d" package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config


# Git稀疏克隆，只克隆指定目录到本地/package 目录下
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}



# gpt 克隆
# Git稀疏克隆，haibo  目录
function git_pas_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mkdir -p "../package/openwrt-packages/"
  mv -f $@ ../package/openwrt-packages/
  cd .. && rm -rf $repodir
}






# ------------------------Alan的插件-----------------------------1.仓库根目录用 git clone           
# ---------------------------------------------------------------2.多目录指定或要进下级目录 用 svn export
# ---------------------------------------------------------------3.依赖包用echo指定到feeds，会自动安装依赖，clone 或者 svn export 指定luci插件
# 腾讯云DDNS
# git clone --depth=1 https://github.com/Alan-tantcw/luci-app-tencentddns package/luci-app-tencentddns
# ipsec插件  vpn
# git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-ipsec-server
# softEther (不启用)
# svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-softethervpn package/luci-app-softethervpn

# 科学上网插件
# #方案1  方案2 --------------------------------ssr-------------------------------------------------------------
# git clone --depth=1 https://github.com/fw876/helloworld package/helloworld

# #方案2 --------------------------------passwall---------------------------------------------------------------
# git_pas_clone master https://github.com/haiibo/openwrt-packages openwrt-passwall
# git_pas_clone master https://github.com/haiibo/openwrt-packages luci-app-passwall

# #方案3-----------------------------------vssr--------------------------------------------------------------------
# git clone --depth=1 https://github.com/fw876/helloworld package/openwrt-packages/helloworld
# git clone --depth=1 https://github.com/ipenwrt/luci-app-vssr package/openwrt-packages/luci-app-vssr
# git_pas_clone main https://github.com/kenzok8/small-package lua-maxminddb

# #docker---
# git_sparse_clone main https://github.com/kenzok8/small-package docker
# git_sparse_clone main https://github.com/kenzok8/small-package dockerd
# git_sparse_clone main https://github.com/kenzok8/small-package luci-app-dockerman


# 添加额外插件
# git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
# git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
# svn export https://github.com/syb999/openwrt-19.07.1/trunk/package/network/services/msd_lite package/msd_lite


# Themes
# git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth=1 -b openwrt-24.10 https://github.com/sbwml/luci-theme-argon.git package/luci-theme-argon

# 更改 Argon 主题背景
# cp -f $GITHUB_WORKSPACE/images/bg.webp package/luci-theme-argon/luci-theme-argon/htdocs/luci-static/argon/img/bg.webp
cp -f $GITHUB_WORKSPACE/images/bg.webp package/luci-theme-argon/htdocs/luci-static/argon/img/bg.webp


# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Alan.Tan/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 Docker 到 服务 菜单
sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

# 调整 ZeroTier 到 服务 菜单
# sed -i 's/vpn/services/g; s/VPN/Services/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
# sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/luasrc/view/zerotier/zerotier_status.htm

# 取消对 samba4 的菜单调整
# sed -i '/samba4/s/^/#/' package/lean/default-settings/files/zzz-default-settings

./scripts/feeds update -a
./scripts/feeds install -a
make -j4
