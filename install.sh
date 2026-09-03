#!/usr/bin/env bash

echo "开始安装 Windows 11 Server 模拟器..."

if [ ! -d "$HOME/bin" ]; then
    mkdir -p "$HOME/bin"
    echo "已创建 ~/bin 目录"
fi

if ! grep -q 'export PATH=$PATH:$HOME/bin' ~/.bashrc 2>/dev/null; then
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    echo "已添加 ~/bin 到 PATH"
fi

echo "正在从 GitHub 下载最新脚本..."
if curl -L -o "$HOME/bin/windows" "https://raw.githubusercontent.com/xiaofangii2/windows-emulator/main/windows.sh" 2>/dev/null; then
    chmod +x "$HOME/bin/windows"
    echo "下载完成！"
else
    echo "下载失败，请检查网络连接"
    exit 1
fi

echo "安装完成！请执行 source ~/.bashrc 或重新打开终端后输入 windows 使用"
