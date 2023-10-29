source /smpoo_file/.lib/v2.0.0/src/tEcho.sh

mgr() {
	tEcho.info "请输入提交备注："
	read commitMemo
	if [ -n "${commitMemo}" ]; then
		sudo git add .
		sudo git commit -m ${commitMemo}
		git push -u origin $(git rev-parse --abbrev-ref HEAD)
	else
		mgr
	fi
}

clear
mgr
