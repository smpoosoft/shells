# 类似jsDoc，扫描传入的路径，对其下的sh脚本文件创建 makeDown 说明文档。
function shellDoc() {
    # 内部函数：生成 Markdown 文档
    function mdCreator() {
        local doc="$1"
        local function_name="$2"
        local comment_block="$3"

        echo -e "## 函数名称：$function_name\n\n$comment_block\n" >> "$doc"
    }

    # 内部函数：生成 JSON 文档
    function jsonCreator() {
        local doc="$1"
        local function_name="$2"
        local comment_block="$3"

        echo -e "{\n  \"函数名称\": \"$function_name\",\n  \"注释\": \"$comment_block\"\n}\n" >> "$doc"
    }

    # 获取参数
    local dir="$1"

    # 创建 docs 目录
    mkdir -p "$dir/docs"

    # 遍历目录中的每个文件和子目录
    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            # 如果是子目录，递归调用 shellDoc 函数
            shellDoc "$item"
        elif [ -f "$item" ] && [[ "$item" == *.sh ]]; then
            # 如果是 Shell 脚本文件，生成文档
            local filename=$(basename -- "$item")
            local name="${filename%.*}"
            local doc="$dir/docs/$name.md"
            local json="$dir/docs/$name.json"

            echo "生成文档：$doc"

            # 初始化变量
            local in_comment_block=false
            local comment_block=""
            local function_name=""

            # 遍历每一行
            while IFS= read -r line; do
                # 检查是否在注释块中
                if $in_comment_block; then
                    # 如果这一行是空行或者函数定义，那么结束注释块
                    if [[ -z $line || $line =~ ^function ]]; then
                        in_comment_block=false

                        # 如果这一行是函数定义，那么打印函数名称和注释块
                        if [[ $line =~ ^function ]]; then
                            function_name=$(echo "$line" | awk '{print $2}')
                            mdCreator "$doc" "$function_name" "$comment_block"
                            jsonCreator "$json" "$function_name" "$comment_block"
                        fi

                        # 清空注释块
                        comment_block=""
                    else
                        # 否则，添加这一行到注释块
                        comment_block="$line\n$comment_block"
                    fi
                fi

                # 检查是否在注释的预备阶段
                if [[ $line =~ ^# && ! $line =~ ^#!/ ]]; then
                    in_comment_block=true
                fi
            done < "$item"
        fi
    done

    echo "请选择输出格式："
    echo "1. Markdown"
    echo "2. JSON"
    read -p "输入你的选择（默认为 1）：" choice

    case "$choice" in
        2) mv "$dir/docs/*.json" "$dir/docs/" ;;
        *) mv "$dir/docs/*.md" "$dir/docs/" ;;
    esac

}

shellDoc
