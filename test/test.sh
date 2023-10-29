testIp() {
	clear
# "curl ifconfig.co" "curl ifconfig.me" "curl icanhazip.com" "curl ident.me" "curl ipinfo.io/ip/" "curl api.ipify.org" "dig +short myip.opendns.com @resolver1.opendns.com" "dig ANY +short @resolver2.opendns.com myip.opendns.com; echo"

}

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
    end=$(date +%s.%N)
    runtime=$(python -c "print((${end} - ${start}) * 1000)")
    formatted_runtime=$(printf "%.3f" $runtime)
    echo "{ result: \"$result\", time: ${formatted_runtime}, cmd: \"$1\" }"
}

execCmd() {
	clear
    for cmd in "${@}"; do
        countCmd "$cmd"
    done
}

execCmd "${ARR_CMD[@]}"


#  15021.164ms curl -s ifconfig.co
# 101.229.21.0 30757.704ms curl -s ifconfig.me
#  15021.705ms curl -s icanhazip.com
# 101.229.21.0 5928.504ms curl -s ident.me
# 101.229.21.0 15644.858ms curl -s ipinfo.io/ip/
#  10016.135ms curl -s api.ipify.org
# 101.229.21.0 17458.080ms dig +short myip.opendns.com @resolver1.opendns.com
# dig: couldn't get address for 'resolver2.opendns.com': failure
#  20025.510ms dig ANY +short @resolver2.opendns.com myip.opendns.com; echo
