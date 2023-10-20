#!/bin/bash

# 格式化shell脚本的屏幕显示，如带颜色的输出，或预置颜色的输出。

# 进行常规控制台打印信息
function tEcho.log() {
	echo "日志$1"
}

# 输出蓝色标题信息
function tEcho.info() {
	echo "信息$1"
}

# 输出成功信息
function tEcho.succ() {
	echo "成功$1"
}

# 输出警告信息
function tEcho.warn() {
	echo "警告$1"
}

# 输出异常信息
function tEcho.err() {
	echo "错误$1"
}
