source /smpoo_file/.lib/v2.0.0/src/tSys.sh

# ==================================================
#                shell 屏显控制/格式化
# ==================================================

# region 语义化的彩色控制输出
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
	# 确保 lolcat 已安装
	tSys.ensureCmd "lolcat"
    echo $1 | lolcat
}
# endregion

# region 个性化样式输出
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
    local widthScreen=$(tput cols)

    # 如果没有传入参数 $1，输出一个完整的横线
    if [ -z "$1" ]; then
        printf '%*s\n' $widthScreen | tr ' ' '-'
    else
        # 如果传入了参数 $1，计算其长度
        local lenStr=${#1}
        local widthStr=$(echo -n "$1" | wc -L)
        local widthUnit=$((widthStr + 12))

        if [ $((widthScreen - widthUnit)) -lt 0 ]; then
            printf '%*s\n' $widthScreen | tr ' ' '-'
            # 计算留白空间
            local space=$((widthScreen - widthStr))
            if [ $space -ge 2 ]; then
                # 如果留白空间为奇数，减去1
                if [ $((space % 2)) -eq 1 ]; then
                    space=$((space - 1))
                fi
                # 计算单边留白宽度
                local padding=$((space / 2))
                # 打印：单边留白宽度（个空白） $1 单边留白宽度（个空白）
                printf '%*s%s%*s\n' "$padding" '' "$1" "$padding" ''
            else
                echo "$1"
            fi
            printf '%*s\n' $widthScreen | tr ' ' '-'
        else
			# 计算横线长度
			local lenLine=$(( (widthScreen - widthStr) / 2 - 2 ))
			printf '%-*s  %s  %-*s\n' "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))" "$1" "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))"
            echo
        fi
    fi
}
# endregion
