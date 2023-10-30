#!/bin/bash

# 定义菜单选项
options=("Option 1" "Option 2" "Option 3" "Quit")

# 显示菜单并获取用户选择
CHOICE=$(printf '%s\n' "${options[@]}" | fzy)

echo "You chose: $CHOICE"
