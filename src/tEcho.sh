#!/bin/bash
# echo -e "\\033[0;33m橙色\\033[0m"
# echo -e "\\033[0;32m黄绿色\\033[0m"
# echo -e "\\033[0;32m绿色\\033[0m"
# echo -e "\\033[38;5;240m灰色\\033[0m"
# echo -e "\\033[0;34m蓝色\\033[0m"

# 格式化shell脚本的屏幕显示，如带颜色的输出，或预置颜色的输出。

# 进行常规控制台打印信息
tEcho.log() {
	if [ ! -n "$1" ]; then
		echo -e "\\033[38;5;240m日志\\033[0m"
	else
		echo -e "\\033[38;5;240m$1\\033[0m"
	fi
}

# 输出蓝色标题信息
tEcho.info() {
	if [ ! -n "$1" ]; then
		echo -e "\\033[0;34m信息\\033[0m"
	else
		echo -e "\\033[0;34m$1\\033[0m"
	fi
}

# 输出成功信息
tEcho.succ() {
	if [ ! -n "$1" ]; then
		echo -e "\\033[0;32m成功\\033[0m"
	else
		echo -e "\\033[0;32m$1\\033[0m"
	fi
}

# 输出警告信息
tEcho.warn() {
	if [ ! -n "$1" ]; then
		echo -e "\\033[0;33m警告\\033[0m"
	else
		echo -e "\\033[0;33m$1\\033[0m"
	fi
}

# 输出异常信息
# $1 要附加的异常提示信息，若不提供，则默认输出： “错误”字样
tEcho.err() {
	if [ ! -n "$1" ]; then
		echo -e "\\033[0;31m错误\\033[0m"
	else
		echo -e "\\033[0;31m$1\\033[0m"
	fi
}

# 用 lolcat 的彩虹色方案显示内容
tEcho.color() {
    if ! command -v lolcat > /dev/null 2>&1; then
        echo "tEcho.color 命令依赖于 lolcat，但当前未安装，正在尝试安装..."
        sudo apt-get install -y lolcat
    fi
    echo $1 | lolcat
}

# 打印深普品牌LOGO
tEcho.logo() {
	echo  -e "\033[34m       ___           ___           ___           ___           ___      \033[0m"
	echo  -e "\033[34m      /\\  \\         /\\__\\         /\\  \\         /\\  \\         /\\  \\     \033[0m"
	echo  -e "\033[34m     /::\\  \\       /::|  |       /::\\  \\       /::\\  \\       /::\\  \\    \033[0m"
	echo  -e "\033[34m    /:/\\ \\  \\     /:|:|  |      /:/\\:\\  \\     /:/\\:\\  \\     /:/\\:\\  \\   \033[0m"
	echo  -e "\033[34m   _\\:\\-\\ \\  \\   /:/|:|__|__   /::\\-\\:\\  \\   /:/  \\:\\  \\   /:/  \\:\\  \\  \033[0m"
	echo  -e "\033[34m  /\\ \\:\\ \\ \\__\\ /:/ |::::\\__\\ /:/\\:\\ \\:\\__\\ /:/__/ \\:\\__\\ /:/__/ \\:\\__\\  \033[0m"
	echo  -e "\033[34m  \\:\\ \\:\\ \\/__/ \\/__/--/:/  / \\/__\\:\\/:/  / \\:\\  \\ /:/  / \\:\\  \\ /:/  /  \033[0m"
	echo  -e "\033[34m   \\:\\ \\:\\__\\         /:/  /       \\::/  /   \\:\\  /:/  /   \\:\\  /:/  /  \033[0m"
	echo  -e "\033[34m    \\:\\/:/  /        /:/  /         \\/__/     \\:\\/:/  /     \\:\\/:/  /   \033[0m"
	echo  -e "\033[34m     \\::/  /        /:/  /                     \\::/  /       \\::/  /    \033[0m"
	echo  -e "\033[34m      \\/__/         \\/__/                       \\/__/         \\/__/     \033[0m"
	echo ""
	echo  -e "\033[34m                        上海深普软件有限公司 - www.smpoo.com \033[0m"
}

# 打印宿主机系统信息
tEcho.host() {
	STR_SYS_NAME="`getSysName`"
	showErr "=============================================================================="
	showErr "·                                                                            ·"
	showErr "·                                 集成脚本                                    ·"
	showErr "·                                                                            ·"
	showErr "=============================================================================="
	echo ${STR_SYS_NAME}
	osName=`uname -a`
	echo ""
	echo ""
	echo  -e "\e[44;37;1m WSL内核: \e[0m"
	echo `cat /proc/version`
	echo ""
	echo 系统版本号：$1
	echo 服务器日期：$DATETIME_FORMAT
	echo 服务器 IP ：$IP_ADDR
	echo "power by:   上海深普软件有限公司 - wwww.smpoo.com"
	showLine
	cat /etc/os-release
	echo ""
	echo ""
}

# 输出屏幕等宽的横线
# $1 如果不提供，则全部为屏幕等宽横线
# $1 如果存在，则将$1 嵌入横线正中，左右各4个空白字符
# $1 如果$1本身的长度就已经超出屏幕宽度，则输出格式变为上中下三部分。上下为横线，中间为$1 字符
tEcho.line() {
    # 获取终端的宽度
    local cols=$(tput cols)

    # 如果没有传入参数 $1，输出一个完整的横线
    if [ -z "$1" ]; then
        printf '%*s\n' $cols | tr ' ' '-'
    else
        # 如果传入了参数 $1，计算其长度
        local len=${#1}

        # 如果 $1 的长度小于终端宽度减 12，将其嵌入到横线中
        if [ $len -lt $(($cols - 12)) ]; then
            local padding=$(( (cols - len - 8 + 1) / 2 )) # 向上取整
            printf '%*s' $padding | tr ' ' '-'
            printf '    %s    ' "$1"
            printf '%*s' $((padding - 1)) | tr ' ' '-'   # 减去向上取整带来的额外长度
            if (( (cols - len) % 2 == 0 )); then          # 如果总长度是偶数，添加一个额外的 -
                printf '-'
            fi
            echo
        else
            # 如果 $1 的长度大于或等于终端宽度减 12，输出上中下三部分结构
            printf '%*s\n' $cols | tr ' ' '-'
            printf "%*s\n" $(((${#1}+$cols)/2)) "$1"
            printf '%*s\n' $cols | tr ' ' '-'
        fi
    fi
}


# region 菜单生成器相关
# 列表型菜单界面展示器（仅供界面显示，不返回实际意义的值）
# 取值请使用：menu_list_getter
# $1 菜单标题文本
# $2 菜单列表的文本项（第一项为默认值）
# eg:
# menu_list_selector "请选择：" "${arr[*]}"
function menu_list_selector() {
	arrs=($2)
	idx=1
	defaultVal=""

	echo ""
	showInfo $1
	for menuItem in ${arrs[@]}; do
		if [ "$idx" != "1" ]; then
			echo " ${idx})： ${menuItem}"
		fi
		((idx++))
	done
	showWarn "其他任意键)	${arrs[0]}"
	echo -e $STR_LINE
}
# 是否型菜单界面选择器
# $1 菜单标题文本
# $2 选 y 时的效果说明
# $3 选 n 时的效果说明
# $4 [可选] 默认值，不提供则为 y
# $5 [可选] 对本交互提示的附加说明，采用分行文本数组
# eg:(完整示例)
# menu_true_false_selector "请选择：" "为 y/Y 时的选择" "为 n/N 时的选择" "n"
function menu_true_false_selector() {
	defaultVal="y"
	defaultTitle="是"
	showInfo "$1"
	if [ "$5" != "" ]; then
		arrs=($5)
		for menuItem in ${arrs[@]}; do
			echo -e " $menuItem"
		done
		echo -e "--------------------------------"
	fi

	strY="y) $2"
	strN="n) $3"
	showSucc "y/Y) $2"
	showErr "n/N) $3"
	if [ "$4" != "" ]; then
		defaultVal="$4"
	fi
	if [ "$4" == "y" ]; then
		defaultTitle="是"
	else
		defaultTitle="否"
	fi
	echo -e "--------------------------------"
	echo " 其他任意键代表：$defaultTitle"
}
# 列表型菜单交互值获取器
# $1 与 menu_list_selector 函数同源的备选菜单项数组
# $2 输入长度限制，默认为 1
# $3 [可选] 输入的索引值对应的 key 值列表，如果不填写，则返回索引值对应的显示文本
# eg:
# menu_list_getter "${arr[*]}"
function menu_list_getter() {
	inputLimt=1
	if [ "$2" != "" ]; then
		inputLimt="$2"
	fi
	# echo "请输入您的选择："
	read resInput

	arrs=($1)
	arrVals=()
	if [ "$3" != "" ]; then
		arrVals=($3)
	fi
	selectIdx=0
	if [[ "$resInput" == "" ]] || [[ $resInput -gt ${#arrs[*]} ]] || [[ $resInput -lt 0 ]]; then
		selectIdx=0
	else
		# selectIdx=`expr $gitIdx - 1`
		selectIdx=$(($resInput-1))
	fi

	if [[ ${#arrVals[@]} -gt 0 ]]; then
		echo ${arrVals[$selectIdx]}
	else
		echo ${arrs[$selectIdx]}
	fi
}
# 是否型菜单交互值获取器
# $1 与 menu_true_false_selector 函数同源的默认值，若不提供，则为 y
# eg:
# showMenu_Yn "n"
function menu_true_false_getter() {
	read -s -n 1 resInput
	currVal=$resInput
	if echo "$resInput" | grep -qwi "y"
	then
		echo "y"
	elif echo "$resInput" | grep -qwi "n"
	then
		echo "n"
	else
		if [ "$1" != "" ]; then
			echo "$1"
		else
			echo "y"
		fi
	fi
}
# endregion
