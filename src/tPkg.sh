source /smpoo_file/.lib/v2.0.0/src/tMenu.sh
source /smpoo_file/.lib/v2.0.0/src/tPath.sh
source /smpoo_file/.lib/v2.0.0/src/tEcho.sh

# 更新 package.json 文件的版本号
	# $1 代表 package.json 文件所在的路径，通常在发起 tPkg.reVer 函数调用的入口函数中，传入 pwd 对应的结果
tPkg.reVer() {
	if [ ! -n "$1" ]; then
		tEcho.err "tPkg.reVer 函数需要传入一个 package.json 文件所在地址的参数才能运行，通常，你可以在入口函数文件中使用 \"\$(pwd)\" 获取这个参数。"
		exit
	fi
	pathRoot="$1"
	verType=$(tMenu.select "${pathRoot}/src/.data/menus/pkgPolicy.jsonc")
	sudo npm version ${verType}
}

tPkg.getKey() {
    local targetDir="$(tPath.folder.getParent "$1")"
    local pkgFile="${targetDir}/package.json"

    if [ ! -e "$pkgFile" ]; then
        tEcho.err "Error: Path '${targetDir}' does not contain a 'package.json' file." 1
    fi

    local fields=("${@:2}")

    if [ "${#fields[@]}" -eq 0 ]; then
        tEcho.err "Error: The tPkg.getKey function must provide at least one field in \$2 for the expected output from the 'package.json' file." 1
    fi

    local fieldValue
    local result=()

    for field in "${fields[@]}"; do
        if ! fieldValue=$(jq -r ".$field" "$pkgFile"); then
            tEcho.err "Error: Path '${targetDir}/package.json' file is missing the '$field' field." 1
        fi
        result+=("$fieldValue")
    done

    printf "%s\n" "${result[@]}"
}
