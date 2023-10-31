source /smpoo_file/.lib/v2.0.0/src/tEcho.sh
source /smpoo_file/.lib/v2.0.0/src/tMenu.sh
source /smpoo_file/.lib/v2.0.0/src/tPkg.sh

# ==================================================
#                github 管理/辅助
# ==================================================

# 在 Git 中，没有内置的命令可以直接获取版本号最大的分支。但是，你可以使用一些 Shell 命令来实现这个功能。以下是一个示例：
# git branch -r | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1
# 在这个示例中：
# git branch -r 命令会列出所有远程分支1。
# grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' 命令会从这些分支中提取出符合 vX.X.X 格式的版本号1。
# sort -V 命令会按照版本号进行排序1。
# tail -n 1 命令会获取最后一行，也就是版本号最大的那个1。
# 需要注意的是，这个命令只适用于版本号完全符合 vX.X.X 这种格式的情况

tGit.init() {
	tEcho.info "仓库初始化"
}

# 将当前项目推送到远端仓库
# $1 代表 package.json 文件所在的路径，通常在发起 tGit.push 函数调用的入口函数中，传入 pwd 对应的结果
tGit.push() {
	if [ ! -n "$1" ]; then
		tEcho.err "tGit.push 函数需要传入一个 package.json 文件所在地址的参数才能运行，通常，你可以在入口函数文件中使用 \"\$(pwd)\" 获取这个参数。"
		exit
	fi
	pathRoot="$1"
	if [ ! -f "${pathRoot}/package.json" ]; then
		tEcho.err "当前路径不存在 package.json 文件，即将退出"
		exit 1
	else
		tEcho.info "请输入提交备注(备注中的引号用反斜杠转义)："
		read commitMemo
		if [ -n "${commitMemo}" ]; then
			gitEnvType=$(tMenu.select "${pathRoot}/src/.data/menus/gitEnvType.jsonc")
			echo ""
			echo ""
			if [ "${gitEnvType}" == "y" ]; then
				tEcho.info "项目将发布为生产版本"
			else
				tEcho.warn "项目将发布为开发版本"
			fi
			echo ""
			echo ""

			sudo git add .
			sudo git commit -m "${commitMemo}"
			tPkg.reVer "$1"
			if sudo git push -u origin $(git rev-parse --abbrev-ref HEAD)
			then
				echo ""
				echo ""
				tEcho.succ "发布成功！"
			else
				echo ""
				echo ""
				tEcho.err "发布失败！"
			fi
			echo ""
			echo ""
		else
			mgr
		fi
	fi
}
