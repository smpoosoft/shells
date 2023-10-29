# ==================================================
#                系统管理/辅助
# ==================================================

# 定义待安装的全局数组变量 ARR_CMD
declare -a ARR_CMD=("lolcat")

# 确保 $1 代表的程序或命令已安装，若未安装，则会立即执行安装
tSys.ensureCmd() {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 准备安装：${1} ..."
        sudo apt-get install -y $1
    fi
}

# 批量初始化系统环境所必须的程序或命令的安装
    # 函数接受一个可选的 $1，注意如果提供 $1 的话，确保 $1 为字符串，若字符串中有空格，会被视作多个数组元素，与 ARR_CMD 合并去重
    # 使用 initCmd 范例：
    # initCmd "foo bar"
    # initCmd "foo"
    # initCmd
    # 或者：
    # declare -a ARR_CMD2=("foo" "bar")
    # initCmd ${ARR_CMD2}
    #
    # @return 返回的是本次执行安装的所有程序的名称排序结果（字母正序排序）
tSys.initCmd() {
    # 如果没有提供 $1，cmds 从 ARR_CMD 取值
    # 如果提供了 $1，则取 $1 和 ARR_CMD 的去重并集
    local cmds
    if [ -z "$1" ]; then
        cmds=${ARR_CMD[@]}
    else
        cmds=$(echo ${ARR_CMD[@]} $1 | tr ' ' '\n' | sort -u | tr '\n' ' ')
    fi

    # 调用 ensureCmd 安装所有程序
    ensureCmd $cmds

    # 返回 cmds 的字母顺序排序后的结果
    echo $(echo $cmds | tr ' ' '\n' | sort | tr '\n' ' ')
}

# 操作前达成确认
    # $1 为一个待执行的函数的名称，该参数不能为空
    # $2 [可选]：
    #      - 当 $2 为纯文本时，代表操作前确认的提示文本
    #      - 当 $2 为数组时，$2[0] 代表操作前确认的提示文本，$2[1] 接受 y/Y 或 n/N 四种字符，代表函数 tSys.next 函数的调用者，希望任意键代表的是 Y 还是 N
    #        * tSys.next foo "确认信息"                                             # （任意键为 允许继续执行)
    #        * tSys.next foo '("确认信息" "n")'                                     # （任意键为 拒绝继续执行)
    #        * tSys.next foo '("确认信息" "y")'                                     # （任意键为 允许继续执行)
    # $3...$n [可选]： 如果交互响应中，确认了进行下一步操作，同时 $3 ~ $n 存在的话， $3 ~ $n 将会传递给 $1 对应的函数
    # 用法示例：
    # 假设 函数 foo 需要三个参数，可以像下面这样使用 tSys.next
    #   tSys.next foo "确认信息" "arg1" "arg2" "arg3"
    #   tSys.next foo '("确认信息" "n")' "arg1" "arg2" "arg3"
    #   tSys.next foo '("确认信息" "y")' "arg1" "arg2" "arg3"
tSys.next() {
  if [ -z "$1" ]; then
	echo -e "\\033[0;31m缺少执行函数\\033[0m"
  else
    local prompt
    local defaultAnswer="y"
    if [ -n "$2" ]; then
        if [ "${2:0:1}" = "(" ]; then
            eval local -a arr=$2
            prompt=${arr[0]}
            defaultAnswer=${arr[1]}
        else
            prompt=$2
        fi
        echo -e $prompt
    fi

    read -p "是否确认并继续（Y/n）？" answer

    if [ "$defaultAnswer" = "y" ] || [ "$defaultAnswer" = "Y" ]; then
        if [ "$answer" = "n" ] || [ "$answer" = "N" ]; then
            exit
        fi
    else
        if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
            exit
        fi
    fi

    $1 "${@:3}"
  fi
}

# 获取本机内网IP地址
tSys.ip.local() {
    # echo $(/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
    # ip route get 8.8.8.8 | awk '{print $NF; exit}' # 实际上 ip route get 8.8.8.8 已经可以从众多网卡接口中定位到当前使用的网卡，但是后面的 wak 过滤有问题
    hostname -I | awk '{print $1}'
}

# 获取本机公网IP
    # 该函数调用了第三方资源和网站，需要耗费相对较多的运行时间。
    # 因此应该用在对公网IP信息有必要性的场景，或者借助公网IP获取确保外网正常的情形。
tSys.ip.public() {
    # 可用命令包括：
    # curl ifconfig.co
    # curl ifconfig.me
    # curl icanhazip.com
    # curl ident.me
    # curl ipinfo.io/ip/
    # curl api.ipify.org
    # dig +short myip.opendns.com @resolver1.opendns.com
    # dig ANY +short @resolver2.opendns.com myip.opendns.com
    ip=$(python ./util/py/getIp.py)
    echo ${ip}
}
