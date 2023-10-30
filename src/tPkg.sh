source /smpoo_file/.lib/v2.0.0/src/tMenu.sh

# 更新 package.json 文件的版本号
tPkg.reVer() {
	verType=$(tMenu.select ./.data/menus/pkgPolicy.jsonc)
	npm version ${verType}
}
