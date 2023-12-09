source /smpoo_file/.lib/v2.0.0/src/tDate.sh
source /smpoo_file/.lib/v2.0.0/src/tEcho.sh

# 如果指定路径下的文件夹，是以日期时间格式命名，则会返回文件夹名称中代表的日期时间最大（距今最近）的文件夹名称
  # $1 代表要搜索扫描的目标路径，该路径下存放了以日期时间命名的文件夹
tPath.folder.max() {
  if [ -z "$1" ]; then
    tEcho.err "tPath.folder.max 函数必须提供一个传入参数 \$1，用于代表要搜索结果的路径"
    exit 1
  fi

  local dir=$1
  local subdirs=$(ls -d $dir/*/ | grep '/')
  # 添加排序过滤
  IFS=$'\n'
  subdirs=($(sort -r <<<"$subdirs"))
  latest_subdir=${subdirs[0]}
  echo "$latest_subdir"
}

# 在指定路径创建一个以日期时间命名的文件夹
  # $1 待创建的文件夹的目标路径（可以含尾斜杠，也可以不含，函数内会自行处理）
  # $2 [可选]：要创建的文件夹的名称，如果忽略，则自动以当前的日期时间命名，格式为： YYYY_MM_DD_HH_MI_SS
tPath.folder.date() {
  if [ -z "$1" ]; then
    tEcho.err "tPath.folder.date 函数必须提供一个传入参数 \$1，用于代表要创建文件夹的目标路径"
    exit 1
  fi

  # 设置文件夹名称，如果 $2 未提供，则文件夹名称以 foo 代替
  dir_name=${2:-$DATETIME_FORMAT}

  # 创建文件夹，如果 $1 存在尾斜杠，则消除
  sudo mkdir -p "${1%/}/$dir_name"
}

# 以当前路径为基准，返回指定层级的上级路径
  # $1 代表要获取的第几级上级
  # eg. 当前目录为 /foo/bar5/bar4/bar3/bar2/bar1/bar
  #
  # tPath.folder.getParent 1，返回当前目录的第1层上级： /foo/bar5/bar4/bar3/bar2/bar1
  # tPath.folder.getParent 不带参数的时候，是 getParentDir 1 的缺省用法
  # tPath.folder.getParent 2，返回当前目录的第2层上级： /foo/bar5/bar4/bar3/bar2
  # tPath.folder.getParent 3，返回当前目录的第3层上级： /foo/bar5/bar4/bar3
  # 依次类推，当 $1 的值超出当前目录的最大上级层数，本例中为 6 时，控制台输出错误提示后，终止进程退出
tPath.folder.getParent() {
    local levels="${1:-1}"  # 默认为 1
    local initialDir="$(pwd)"
    local currentDir="$initialDir"

    for ((i=1; i<=levels; i++)); do
        if [ "$currentDir" == "/" ]; then
            tEcho.err "Error: The argument \"\$1=$1\" exceeds the maximum levels of the current path: \"${initialDir}\"." 1
        fi
        currentDir="$(dirname "$currentDir")"
    done

    echo "$currentDir"
}
