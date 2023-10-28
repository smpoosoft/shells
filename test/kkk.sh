#!/bin/bash

# 用 wc -L 替换了字符宽度计算
tEcho.line.wcl() {
    # 获取终端的宽度
    local widthScreen=$(tput cols)

    # 如果没有传入参数 $1，输出一个完整的横线
    if [ -z "$1" ]; then
        printf '%*s\n' $widthScreen | tr ' ' '-'
    else
        # 如果传入了参数 $1，计算其长度
        local lenStr=${#1}
        local widthStr=$(echo -n "$1" | wc -L)
        local widthUnit=$((widthStr + 12))

        if [ $((widthScreen - widthUnit)) -lt 0 ]; then
            printf '%*s\n' $widthScreen | tr ' ' '-'
            echo "$1"
            printf '%*s\n' $widthScreen | tr ' ' '-'
        else
			# 计算横线长度
			local lenLine=$(( (widthScreen - widthStr) / 2 - 2 ))
			printf '%-*s  %s  %-*s\n' "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))" "$1" "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))"
            echo
        fi
    fi
}

#
tEcho.line() {
    # 获取终端的宽度
    local widthScreen=$(tput cols)

    # 如果没有传入参数 $1，输出一个完整的横线
    if [ -z "$1" ]; then
        printf '%*s\n' $widthScreen | tr ' ' '-'
    else
        # 如果传入了参数 $1，计算其长度
        local lenStr=${#1}
        local widthStr=$(echo -n "$1" | wc -L)
        local widthUnit=$((widthStr + 12))

        if [ $((widthScreen - widthUnit)) -lt 0 ]; then
            printf '%*s\n' $widthScreen | tr ' ' '-'
            # 计算留白空间
            local space=$((widthScreen - widthStr))
            if [ $space -ge 2 ]; then
                # 如果留白空间为奇数，减去1
                if [ $((space % 2)) -eq 1 ]; then
                    space=$((space - 1))
                fi
                # 计算单边留白宽度
                local padding=$((space / 2))
                # 打印：单边留白宽度（个空白） $1 单边留白宽度（个空白）
                printf '%*s%s%*s\n' "$padding" '' "$1" "$padding" ''
            else
                echo "$1"
            fi
            printf '%*s\n' $widthScreen | tr ' ' '-'
        else
			# 计算横线长度
			local lenLine=$(( (widthScreen - widthStr) / 2 - 2 ))
			printf '%-*s  %s  %-*s\n' "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))" "$1" "$lenLine" "$(printf '%.0s-' $(seq 1 $lenLine))"
            echo
        fi
    fi
}


tEcho.line $1
