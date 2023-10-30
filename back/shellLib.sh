#!/bin/bash
PATH_GIT="git@github.com:smpoosoft/shells.git"
PATH_LIB="/smpoo_file/.lib"
VER="v2.0.0"

# 检查文件夹是否存在
if [ ! -d "${PATH_LIB}/${VER}" ]; then
    echo "文件夹不存在，开始从 GitHub 下载..."

    # 从 GitHub 下载指定版本的仓库
    sudo git clone --branch v1.0.0 ${PATH_GIT} ${PATH_LIB}/${VER}
fi

# 引用脚本
# smpoo 项目或规范方面的辅助函数
source "${PATH_LIB}/${VER}/src/smpoo.sh"
# 日期辅助函数
source "${PATH_LIB}/${VER}/src/tDate.sh"
# 控制台辅助函数
source "${PATH_LIB}/${VER}/src/tEcho.sh"
#  github 操作辅助函数
source "${PATH_LIB}/${VER}/src/tGit.sh"
#  终端屏显菜单辅助函数
source "${PATH_LIB}/${VER}/src/tMenu.sh"
# docker 辅助函数
source "${PATH_LIB}/${VER}/src/tDocker.sh"
# podman 辅助函数
source "${PATH_LIB}/${VER}/src/tPodman.sh"
# ssh 辅助函数
source "${PATH_LIB}/${VER}/src/tSsh.sh"
# ssl 辅助函数
source "${PATH_LIB}/${VER}/src/tSsl.sh"
# 系统层面的辅助函数
source "${PATH_LIB}/${VER}/src/tSys.sh"
