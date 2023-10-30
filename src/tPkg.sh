source /smpoo_file/.lib/v2.0.0/src/tMenu.sh

# 更新 package.json 文件的版本号
	# $1 代表 package.json 文件所在的路径，通常在发起 tPkg.reVer 函数调用的入口函数中，传入 pwd 对应的结果
tPkg.reVer() {
	if [ ! -n "$1" ]; then
		tEcho.err "tPkg.reVer 函数需要传入一个 package.json 文件所在地址的参数才能运行，通常，你可以在发起 tPkg.reVer 函数调用的入口函数中，传入 pwd 对应的结果"
		exit
	fi
	verType=$(tMenu.select ./.data/menus/pkgPolicy.jsonc)
	npm version ${verType}
}
