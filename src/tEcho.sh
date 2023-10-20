#!/bin/bash

# 格式化shell脚本的屏幕显示，如带颜色的输出，或预置颜色的输出。

# 进行常规控制台打印信息
function tlog() {
	echo "日志"
}

# 输出蓝色标题信息
function tInfo() {
	echo "信息"
}

# 输出成功信息
function tSucc() {
	echo "成功"
}

# 输出警告信息
function tWarn() {
	echo "警告"
}

# 输出异常信息
function tErr() {
	echo "错误"
}
