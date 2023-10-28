source ./tEcho.sh

# ==================================================
#                smpoo 工具或规范库
# ==================================================

# 打印深普品牌LOGO
smpoo.logo() {
	echo  -e "\033[34m       ___           ___           ___           ___           ___      \033[0m"
	echo  -e "\033[34m      /\\  \\         /\\__\\         /\\  \\         /\\  \\         /\\  \\     \033[0m"
	echo  -e "\033[34m     /::\\  \\       /::|  |       /::\\  \\       /::\\  \\       /::\\  \\    \033[0m"
	echo  -e "\033[34m    /:/\\ \\  \\     /:|:|  |      /:/\\:\\  \\     /:/\\:\\  \\     /:/\\:\\  \\   \033[0m"
	echo  -e "\033[34m   _\\:\\-\\ \\  \\   /:/|:|__|__   /::\\-\\:\\  \\   /:/  \\:\\  \\   /:/  \\:\\  \\  \033[0m"
	echo  -e "\033[34m  /\\ \\:\\ \\ \\__\\ /:/ |::::\\__\\ /:/\\:\\ \\:\\__\\ /:/__/ \\:\\__\\ /:/__/ \\:\\__\\  \033[0m"
	echo  -e "\033[34m  \\:\\ \\:\\ \\/__/ \\/__/--/:/  / \\/__\\:\\/:/  / \\:\\  \\ /:/  / \\:\\  \\ /:/  /  \033[0m"
	echo  -e "\033[34m   \\:\\ \\:\\__\\         /:/  /       \\::/  /   \\:\\  /:/  /   \\:\\  /:/  /  \033[0m"
	echo  -e "\033[34m    \\:\\/:/  /        /:/  /         \\/__/     \\:\\/:/  /     \\:\\/:/  /   \033[0m"
	echo  -e "\033[34m     \\::/  /        /:/  /                     \\::/  /       \\::/  /    \033[0m"
	echo  -e "\033[34m      \\/__/         \\/__/                       \\/__/         \\/__/     \033[0m"
	echo ""
	echo  -e "\033[34m                        上海深普软件有限公司 - www.smpoo.com \033[0m"
}

# 保持深普统一的全局路径结构
	# 函数必须传入 $1 值，代表深普根目录，通常值为 smpoo_file
smpoo.schame.folder.base() {
	taskName="全局目录初始化"
	if [ -n "$1" ]; then
		base_folder="$1"
		tEcho.info "${taskName}..."

		dbTypes1="mongo"
		dbTypes2="mysql"
		dbTypes3="postgres"
		dbTypes4="redis"
		dbTypes5="meilisearch"
		dbTypes6="minio"

		toolsType1=codeServer
		toolsType2=firefoxSend
		toolsType3=frp
		toolsType4=gitLab
		toolsType5=noVnc
		toolsType6=svn
		toolsType7=verdaccio

		# 在首次初始化时初始化根目录
		sudo mkdir -pv $SMPOO_ROOT/.env/nginx/cert
		sudo mkdir -pv $SMPOO_ROOT/.env/nginx/conf
		sudo mkdir -pv $SMPOO_ROOT/.env/nginx/_letsencrypt
		sudo mkdir -pv $SMPOO_ROOT/.env/db
		sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal
		sudo mkdir -pv $SMPOO_ROOT/.env/svn/repo

		sudo mkdir -pv $SMPOO_ROOT/docker

		sudo mkdir -pv $SMPOO_ROOT/logs/nginx
		sudo mkdir -pv $SMPOO_ROOT/logs/db

		sudo mkdir -pv $SMPOO_ROOT/backup/nginx
		sudo mkdir -pv $SMPOO_ROOT/backup/db

		sudo mkdir -pv $SMPOO_ROOT/common/.smpoo
		sudo mkdir -pv $SMPOO_ROOT/project
		sudo mkdir -pv $SMPOO_ROOT/scripts
		sudo mkdir -pv $SMPOO_ROOT/tools

		# DB
		for dbItem in $dbTypes1 $dbTypes2 $dbTypes3 $dbTypes4 $dbTypes5 $dbTypes6;
		do
			sudo mkdir -pv $SMPOO_ROOT/.env/db/$dbItem/conf
			sudo mkdir -pv $SMPOO_ROOT/.env/db/$dbItem/data
		done

		# Tools
		for toolsTypeItem in $toolsType1 $toolsType2 $toolsType3 $toolsType4 $toolsType5 $toolsType6 $toolsType7;
		do
			sudo mkdir -pv $SMPOO_ROOT/.env/$toolsTypeItem/conf
			sudo mkdir -pv $SMPOO_ROOT/.env/$toolsTypeItem/data
		done

		# nodeJs 全局
		nodeVers1=haya
		nodeVers2=tmind
		nodeVers3=tcoffe
		for nodeVersItem in $nodeVers1 $nodeVers2 $nodeVers3;
		do
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/npmRepo/cache
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/npmRepo/global

			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/pnpmRepo/.store
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/pnpmRepo/cache
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/pnpmRepo/global

			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/yarnRepo/cache
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/yarnRepo/global
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/yarnRepo/link
			sudo mkdir -pv $SMPOO_ROOT/.env/nodeGlobal/$nodeVersItem/yarnRepo/offline
		done

		# 日志
		cd /
		for dbItem in $dbTypes1 $dbTypes2 $dbTypes3 $dbTypes4 $dbTypes5 $dbTypes6;
		do
			sudo mkdir -pv $SMPOO_ROOT/logs/db/$dbItem
		done

		# 备份
		for dbItem in $dbTypes1 $dbTypes2 $dbTypes3 $dbTypes4 $dbTypes5 $dbTypes6;
		do
			sudo mkdir -pv $SMPOO_ROOT/backup/db/$dbItem
		done

		# 备份文件夹
		sudo chmod  -R 777 $SMPOO_ROOT/backup
		# 公共资源集
		sudo chmod  -R 777 $SMPOO_ROOT/common
		# 日志文件夹
		sudo chmod  -R 777 $SMPOO_ROOT/logs
		# 工程文件夹
		sudo chmod  -R 777 $SMPOO_ROOT/project
		# 运维脚本集
		sudo chmod  -R 777 $SMPOO_ROOT/scripts
		# 运维工具集
		sudo chmod  -R 777 $SMPOO_ROOT/tools

		createProjectFolder haya
		createProjectFolder tmind
		createProjectFolder tcoffe

		setDone ".sysFolderDone"
		setDone ".hayaFolderDone"
		setDone ".tmindFolderDone"
		setDone ".tcoffeFolderDone"
		tEcho.succ "${taskName}成功"
	else
		tEcho.err "smpoo.folder.common 缺少传入参数 \$1"
		exit
	fi
}

# 保持深普统一的项目路径结构
	# 函数必须传入 $1 值，代表平台代码，如 tCofee
	# 函数必须传入 $2 值，代表项目名称
smpoo.schame.folder.project() {
	if [ -z "$1" ]; then
		echo "参数 \$1 不能为空，此处必须传入代表平台代码的字符，如：tCoffe"
		exit
	elif [ -z "$2" ]; then
		echo "参数 \$2 不能为空，此处必须传入代表项目代码的字符"
		exit
	else
		echo "to do..."
	fi
}
