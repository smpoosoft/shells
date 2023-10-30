source /smpoo_file/.lib/v2.0.0/src/tEcho.sh
source /smpoo_file/.lib/v2.0.0/src/tMenu.sh

mgr() {
	tEcho.info "请输入提交备注(备注中的引号用反斜杠转义)："
	read commitMemo
	if [ -n "${commitMemo}" ]; then
		sudo cp -rf ../shellLib.sh ./back/
		gitEnvType=$(tMenu.select ./.dev/menus/gitEnvType.jsonc)
		if [ "${gitEnvType}" == "y" ]; then
			tEcho.info "项目将发布为生产版本"
		else
			tEcho.warn "项目将发布为开发版本"
		fi
		sudo git add .
		sudo git commit -m "${commitMemo}"
		sudo git push -u origin $(git rev-parse --abbrev-ref HEAD)
	else
		mgr
	fi
}

clear
mgr
