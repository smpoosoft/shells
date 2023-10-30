#!/bin/bash
getMenu22() {
	# ensureCmd fzy

	arrKeys=()
	arrTitles=()

	getJson() {
		local file=$1
		local key=""
		local value=""

		while IFS= read -r line
		do
			# 忽略花括号和注释
			if [[ $line =~ ^[[:space:]]*// || $line =~ ^[[:space:]]*/\* || $line =~ ^[[:space:]]*\{ || $line =~ ^[[:space:]]*\} ]]; then
				continue
			fi

			# 解析 key 和 value
			key=$(echo $line | cut -d':' -f1 | tr -d '[:space:]' | tr -d '"' | tr -d "'")
			value=$(echo $line | cut -d':' -f2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | tr -d '"' | tr -d "'" | tr -d ',')

			# 存储到数组中
			arrTitles+=("$value")
			arrKeys+=("$key")
		done < "$file"

		# 检查数组是否为空或元素数量不一致
		if [ ${#arrTitles[@]} -eq 0 ] || [ ${#arrKeys[@]} -eq 0 ] || [ ${#arrTitles[@]} -ne ${#arrKeys[@]} ]; then
			echo "菜单数据无效"
			exit 1
		fi
	}

	getJson $1

	printf "%s\n" "${arrTitles[@]}" | fzy | while read -r line
	do
		for i in "${!arrTitles[@]}"; do
			if [[ "${arrTitles[$i]}" = "${line}" ]]; then
				echo "${arrKeys[$i]}"
				break
			fi
		done
	done
}

getMenu() {
	# ensureCmd fzy

	arrKeys=()
	arrTitles=()

	getJson() {
		local file=$1
		local key=""
		local value=""

		while IFS= read -r line
		do
			# 忽略无效的数据行
			line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
			if [[ $line =~ ^[[:space:]]*// || $line =~ ^[[:space:]]*/\* || $line =~ .*\\\{$ || $line =~ .*\\\}$ || $line =~ .*\\\};$ ]]; then
				continue
			fi

			# 解析 key 和 value
			key=$(echo $line | cut -d':' -f1 | tr -d '[:space:]' | tr -d '"' | tr -d "'")
			value=$(echo $line | cut -d':' -f2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | tr -d '"' | tr -d "'" | tr -d ',' | tr -d ';')

			# 存储到数组中
			arrTitles+=("$value")
			arrKeys+=("$key")
		done < "$file"

		# 检查数组是否为空或元素数量不一致
		if [ ${#arrTitles[@]} -eq 0 ] || [ ${#arrKeys[@]} -eq 0 ] || [ ${#arrTitles[@]} -ne ${#arrKeys[@]} ]; then
			echo "菜单数据无效"
			exit 1
		fi
	}

	getJson $1

	printf "%s\n" "${arrTitles[@]}" | fzy | while read -r line
	do
		for i in "${!arrTitles[@]}"; do
			if [[ "${arrTitles[$i]}" = "${line}" ]]; then
				echo "${arrKeys[$i]}"
				break
			fi
		done
	done
}





clear
# 调用函数
getMenu $1
