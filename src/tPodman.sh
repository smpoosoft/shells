source ./tEcho.sh

# ==================================================
#                podman 管理/辅助
# ==================================================

# 判断是否处于 podman 环境，还是处于宿主机中
    # 用法示例：
    # if inPodman; then
    #     echo "处于 podman 环境中"
    # else
    #     echo "处于宿主机环境中"
    # fi
tPodman.inPodman() {
    grep -q 'container=podman' /proc/1/environ
}

# 彻底清理容器缓存，以及构建失败的镜像及容器
	# 随着 podman 下载的镜像越来越多，通过 podman rmi 命令无法彻底清除 podman 缓存，需要使用下面的命令从根本上清除：
	# 该命令清除：
	#  * 所有停止的容器
	#  * 所有不被任何一个容器使用的网络
	#  * 所有不被任何一个容器使用的volume
	#  * 所有无实例的镜像
	# 以下命令清理得更加彻底，可以将没有容器使用 podman 镜像都删掉。
	# 注意，这两个命令会把暂时关闭的容器，以及暂时没有用到的 podman 镜像都删掉了，
	#
	# ****************** 所以谨慎使用 ********************
	# 如果只是清除 <none> 的镜像或容器，使用全局命令：
	# dockerfix
	#
	# eg:
	# 终端执行：
	# dockerclear
tPodman.pure() {
	sudo podman system prune --volumes -f
}
