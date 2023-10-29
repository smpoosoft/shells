source /smpoo_file/.lib/v2.0.0/src/tEcho.sh

# ==================================================
#                docker 管理/辅助
# ==================================================

# 判断是否处于 docker 环境，还是处于宿主机中
	# 用法示例：
	# if inDocker; then
	# 	echo "处于 docker 环境中"
	# else
	# 	echo "处于宿主机环境中"
	# fi
tDocker.inDocker() {
	grep -qE 'docker|kubepod' /proc/1/cgroup
}

# 结束中的指定容器的运行
	# $1 容器名称或ID
tDocker.stop() {
	if [ -n "$1" ]; then
		sudo docker kill "$1"
	else
		tEcho.err "必须提供 docker 容器的名称或ID"
	fi
}

# 结束所有运行中的容器
tDocker.stop.all() {
	sudo docker kill $(docker ps -a -q)
}

# 移除指定的容器
	# $1 容器名称或ID
tDocker.drop() {
	if [ -n "$1" ]; then
		sudo docker rm -f "$1"
	else
		tEcho.err "必须提供 docker 容器的名称或ID"
	fi
}

# 移除所有的容器
tDocker.drop.all() {
	sudo docker rm -f $(docker ps -a -q)
}

# 移除指定的镜像
	# $1 镜像名称或ID
tDocker.del() {
	if [ -n "$1" ]; then
		sudo docker rmi -f "$1"
	else
		tEcho.err "必须提供 docker 容器的名称或ID"
	fi
}

# 移除所有的镜像
tDocker.del.all() {
	sudo docker rmi -f $(docker images -q)
}

# 彻底清理容器缓存，以及构建失败的镜像及容器
	# 随着 docker 下载的镜像越来越多，通过 docker rmi 命令无法彻底清除 docker 缓存，需要使用下面的命令从根本上清除：
	# 该命令清除：
	#  * 所有停止的容器
	#  * 所有不被任何一个容器使用的网络
	#  * 所有不被任何一个容器使用的volume
	#  * 所有无实例的镜像
	# 以下命令清理得更加彻底，可以将没有容器使用 docker 镜像都删掉。
	# 注意，这两个命令会把暂时关闭的容器，以及暂时没有用到的 docker 镜像都删掉了，
	#
	# ****************** 所以谨慎使用 ********************
	# 如果只是清除 <none> 的镜像或容器，使用全局命令：
	# dockerfix
	#
	# eg:
	# 终端执行：
	# dockerclear
tDocker.pure() {
	sudo docker system prune --volumes -f
}
