# 替换 feeds.conf.default 中的 packages 源
sed -i 's|^src-git packages .*|src-git packages https://github.com/kenzok8/small-package.git|' feeds.conf.default

