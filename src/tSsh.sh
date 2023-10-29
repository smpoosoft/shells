source /smpoo_file/.lib/v2.0.0/src/tEcho.sh

# ==================================================
#                本机的 SSH 密钥管理
# ==================================================

# 将本机的 ssh 公钥添加到指定到远程主机中，达成信任
# $1 为可选的远端主机IP地址，如果不提供，则会在运行时要求手工输入
tSsh.key() {
	tEcho.info "本命令会将本机的.ssh密钥添加到输入的ip地址对应主机中自动授权"
	tEcho.line
	destIP=""
	uName="root"
	if [[ "$1" != "" ]]; then
		destIP=$1
	else
		tEcho.info "请输入要添加密钥的服务器 IP 地址："
		read currIP
		if [[ "$currIP" == "" ]]; then
			tEcho.err "远端 IP 地址不能为空"
			tEcho.info "请重新输入要添加密钥的服务器 IP 地址："
			tEcho.info "或回车退出执行"
			read currIP2
			if [[ "$currIP2" == "" ]]; then
				exit 2
			else
				destIP="$currIP2"
			fi
		else
			destIP="$currIP"
		fi
	fi

	tEcho.info "请输入登陆用户名："
	tEcho.info "默认为（root)："
	read currUserName
	if [[ "$currUserName" != "" ]]; then
		uName="$currUserName"
	fi
	KNOWN_FILE="~/.ssh/known_hosts"
	if [ -f "${KNOWN_FILE}" ]; then
		ssh-keygen -f "~/.ssh/known_hosts" -R "${destIP}"
	fi
	sudo ssh ${uName}@${destIP} "sudo mkdir -pv ~/.ssh"
	sudo scp -r ~/.ssh/id_rsa.pub ${uName}@${destIP}:~/.ssh/
	sudo ssh ${uName}@${destIP} "sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys &&  rm -rf ~/.ssh/id_rsa.pub && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && exit;"
}
