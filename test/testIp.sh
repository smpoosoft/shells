source ../src/tEcho.sh

ARR_CMD=(
	"curl -s ifconfig.co"
	"curl -s ifconfig.me"
	"curl -s icanhazip.com"
	"curl -s ident.me"
	"curl -s ipinfo.io/ip/"
	"curl -s api.ipify.org"
	"dig +short myip.opendns.com @resolver1.opendns.com"
	"dig ANY +short @resolver2.opendns.com myip.opendns.com; echo"
)

countCmd() {
    start=$(date +%s.%N)
    result=$(eval "$1; echo")
    if [ ${#result} -gt 20 ]; then
        result="replaced..."
    fi
    end=$(date +%s.%N)
    runtime=$(python -c "print((${end} - ${start}) * 1000)")
    formatted_runtime=$(printf "%.3f" $runtime)
    output="{ loopIdx: $2, cmdIdx: $3, result: \"$result\", time: ${formatted_runtime}, cmd: \"$1\" }"
    echo "${output}"
    sudo echo "${output}" >> ./iploop
}

execCmd() {
    local cmdIdx=1
    for cmd in "${@:2}"; do
        countCmd "$cmd" "$1" "$cmdIdx"
        ((cmdIdx++))
    done
}

run() {
	if [ -n "$1" ]; then
		tEcho.info "准备开始循环检测公网IP，${1} 次"
		local loopIdx=1
		while ((loopIdx <= $1)); do
			execCmd "$loopIdx" "${ARR_CMD[@]}"
			((loopIdx++))
		done
	else
		tEcho.err "必须输入循环次数"
	fi
}

clear
run $1
