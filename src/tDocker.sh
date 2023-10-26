# 判断是否处于 docker 环境，还是处于宿主机中
# 用法示例：
# if inDocker; then
# 	echo "处于 docker 环境中"
# else
# 	echo "处于宿主机环境中"
# fi
inDocker() {
	grep -qE 'docker|kubepod' /proc/1/cgroup
}
