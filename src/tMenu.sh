# ==================================================
#                shell 屏显菜单辅助函数
# ==================================================

# 生成一个可交互的选择菜单
	# $1 接受一个文件地址，文件支持 json/jsonc/js/mjs/ts 格式。
	# 对于 js/mjs/ts 格式的文件，应该使用 cjs/ems 风格，导出一个 json 对象
	# 无论何种文件格式，最终的 json 对象，键对应的值，作为菜单的屏显文本，键名，则是用户选择后的函数返回值。
	# eg:
	# 有以下的 json 对象
	# {
	#	key1: 'this is key1'
	# }
	# 菜单界面的屏显文本是： this is key1，用户选择了该项后，函数返回 key1
tMenu.select() {
	# 确保 fzy 库已经安装

    local keys=()
    local vals=()

	# 解析 json 文件，或类 json 文件的数据行
	decodeJsonRow() {
		rowStr=$(echo $1 | sed 's/^[ \t]*//;s/[ \t]*$//')
		if [[ $rowStr == *"}" ]] || [[ $rowStr == "{"* ]] || [[ $rowStr == "/**"* ]] || [[ $rowStr == "*"* ]] || [[ $rowStr == "//"* ]] || ! [[ $rowStr == *":"* ]]; then
			echo ""
		else
			key=$(echo $rowStr | cut -d ':' -f 1 | sed 's/^[ \t]*//;s/[ \t]*$//;s/,$//;s/^"//;s/"$//;s/^'\''//;s/'\''$//')
			val=$(echo $rowStr | cut -d ':' -f 2- | sed 's/^[ \t]*//;s/[ \t]*$//;s/,$//;s/^"//;s/"$//;s/^'\''//;s/'\''$//')
			echo "${key}"
			echo "${val}"
		fi
	}

	# 解析 json/jsonc 文件，或 js/mjs/ts 提供的类json 文件
	getJson() {
		local file="$1"
		while IFS= read -r line; do
			if [[ -n "$line" ]]; then
				local ARR_RES=()
				while IFS= read -r row; do
					ARR_RES+=("$row")
				done < <(decodeJsonRow "$line")
				if [[ -n "${ARR_RES[0]}" ]] && [[ -n "${ARR_RES[1]}" ]]; then
					keys+=("${ARR_RES[0]}")
					vals+=("${ARR_RES[1]}")
				fi
			fi
		done < "$file"
	}

    getJson $1

    # 检查 keys 和 vals 数组的元素数量
    if [[ ${#keys[@]} -eq 0 ]] || [[ ${#vals[@]} -eq 0 ]] || [[ ${#keys[@]} -ne ${#vals[@]} ]]; then
        echo "无效的菜单数据"
        exit 1
    fi

    # 使用 fzy 库来创建用户可交互的菜单
    local choice=$(printf '%s\n' "${vals[@]}" | fzy)

    # 找到用户选择的菜单项在 vals 数组中的索引
    local index
    for i in "${!vals[@]}"; do
        if [[ "${vals[$i]}" = "${choice}" ]]; then
            index=$i
            break
        fi
    done

    # 输出 keys 数组中对应的值
    echo "${keys[$index]}"
}
