#!/usr/bin/env bash

# ========== 检测系统 ==========
if [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=1
    HOME_DIR="$HOME/Windows11"
    STOP_FILE="$HOME_DIR/stop"
else
    IS_TERMUX=0
    HOME_DIR="$HOME/Windows11"
    STOP_FILE="/tmp/windows_stop"
fi

# ========== 创建目录 ==========
mkdir -p ~/bin
mkdir -p "$HOME_DIR"
mkdir -p "$HOME_DIR/C:"
mkdir -p "$HOME_DIR/C:/Users/Administrator"

if [ ! -f "$HOME_DIR/status" ]; then
    echo "false" > "$HOME_DIR/status"
fi
if [ ! -f "$HOME_DIR/reboot" ]; then
    echo "false" > "$HOME_DIR/reboot"
fi

if ! grep -q "export PATH=\$PATH:~/bin" ~/.bashrc 2>/dev/null; then
    echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
fi

cp "$0" ~/bin/windows 2>/dev/null
chmod +x ~/bin/windows

PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator"

check_installed() {
    if [ ! -f "$HOME_DIR/status" ]; then
        echo ""
        echo "Segmentation fault (core dumped)"
        echo "Error: Null pointer dereference"
        echo "File: src/windows.c"
        echo "Line: 42"
        echo "Process returned 139 (0x8B) execution time : 0.002 s"
        exit 1
    fi
    if [ "$(cat "$HOME_DIR/status")" != "true" ]; then
        echo ""
        echo "Segmentation fault (core dumped)"
        echo "Error: Null pointer dereference"
        echo "File: src/windows.c"
        echo "Line: 42"
        echo "Process returned 139 (0x8B) execution time : 0.002 s"
        exit 1
    fi
}

check_reboot() {
    if [ ! -f "$HOME_DIR/reboot" ]; then
        echo ""
        echo "Error: System requires reboot to complete installation"
        echo "File: src/windows.c"
        echo "Line: 56"
        echo "Please run 'windows shutdown /r' first"
        echo "Process returned 1 (0x1) execution time : 0.001 s"
        exit 1
    fi
    if [ "$(cat "$HOME_DIR/reboot")" != "true" ]; then
        echo ""
        echo "Error: System requires reboot to complete installation"
        echo "File: src/windows.c"
        echo "Line: 56"
        echo "Please run 'windows shutdown /r' first"
        echo "Process returned 1 (0x1) execution time : 0.001 s"
        exit 1
    fi
}

case $1 in
    install)
        if [ -f "$HOME_DIR/status" ] && [ "$(cat "$HOME_DIR/status")" = "true" ]; then
            echo ""
            echo "Error: Installation already detected!"
            echo "File: $HOME_DIR/status"
            echo "Line: 42"
            echo "Process returned 1 (0x1) execution time : 0.003 s"
            exit 1
        fi

        echo -e "\033[?25l"
        trap 'echo -e "\033[?25h"; exit' EXIT
        trap 'echo -e "\033[?25h"; echo ""; echo "操作已暂停"; exit' INT TERM

        echo "正在安装 Windows 11 Server..."
        echo ""
        echo "按 Ctrl+C 或输入 stop 暂停安装"
        echo ""

        for i in {1..20}; do
            if [ -f "$STOP_FILE" ]; then
                rm -f "$STOP_FILE"
                echo ""
                echo "安装已暂停"
                echo -e "\033[?25h"
                exit 0
            fi
            bar=$(printf '%0.s█' $(seq 1 $i))
            printf "\r%s %d%%" "$bar" $((i*5))
            sleep 0.5
        done

        mkdir -p "$HOME_DIR/C:/system32"
        mkdir -p "$HOME_DIR/C:/Users/Administrator"

        touch "$HOME_DIR/C:/system32/dir"
        touch "$HOME_DIR/C:/system32/ping"
        touch "$HOME_DIR/C:/system32/ipconfig"
        touch "$HOME_DIR/C:/system32/tracert"
        touch "$HOME_DIR/C:/system32/netstat"
        touch "$HOME_DIR/C:/system32/tasklist"
        touch "$HOME_DIR/C:/system32/shutdown"
        touch "$HOME_DIR/C:/system32/systeminfo"
        touch "$HOME_DIR/C:/system32/ver"
        touch "$HOME_DIR/C:/system32/help"
        touch "$HOME_DIR/C:/system32/cls"
        touch "$HOME_DIR/C:/system32/exit"
        touch "$HOME_DIR/C:/system32/echo"
        touch "$HOME_DIR/C:/system32/mkdir"
        touch "$HOME_DIR/C:/system32/rmdir"
        touch "$HOME_DIR/C:/system32/del"
        touch "$HOME_DIR/C:/system32/copy"
        touch "$HOME_DIR/C:/system32/move"
        touch "$HOME_DIR/C:/system32/ren"
        touch "$HOME_DIR/C:/system32/type"
        touch "$HOME_DIR/C:/system32/find"
        touch "$HOME_DIR/C:/system32/taskkill"
        touch "$HOME_DIR/C:/system32/reg"
        touch "$HOME_DIR/C:/system32/sc"
        touch "$HOME_DIR/C:/system32/msconfig"

        echo "true" > "$HOME_DIR/status"
        echo "false" > "$HOME_DIR/reboot"

        echo -e "\033[?25h"
        echo ""
        echo ""
        echo "安装完成！请重启系统。"
        echo "输入 windows shutdown /r 重启"
        ;;
    stop)
        touch "$STOP_FILE"
        echo "正在暂停操作..."
        ;;
    version)
        check_installed
        check_reboot
        echo "Windows 11 Server 25H2"
        ;;
    uninstall)
        check_installed
        check_reboot

        echo -e "\033[?25l"
        trap 'echo -e "\033[?25h"; exit' EXIT
        trap 'echo -e "\033[?25h"; echo ""; echo "操作已暂停"; exit' INT TERM

        echo "正在卸载 Windows 11 Server..."
        echo ""
        echo "按 Ctrl+C 或输入 stop 暂停卸载"
        echo ""

        for i in {1..20}; do
            if [ -f "$STOP_FILE" ]; then
                rm -f "$STOP_FILE"
                echo ""
                echo "卸载已暂停"
                echo -e "\033[?25h"
                exit 0
            fi
            bar=$(printf '%0.s█' $(seq 1 $i))
            printf "\r%s %d%%" "$bar" $((i*5))
            sleep 0.3
        done

        echo "false" > "$HOME_DIR/status"
        echo "false" > "$HOME_DIR/reboot"

        echo -e "\033[?25h"
        echo ""
        echo ""
        echo "卸载完成！"
        echo "Windows 11 Server has been removed from your system."
        ;;
    shutdown)
        check_installed

        if [ "$2" = "/r" ] || [ "$2" = "-r" ]; then
            echo "正在重启系统..."
            echo ""

            for i in {1..20}; do
                bar=$(printf '%0.s█' $(seq 1 $i))
                printf "\r%s %d%%" "$bar" $((i*5))
                sleep 0.3
            done

            echo "true" > "$HOME_DIR/reboot"

            echo ""
            echo ""
            echo "重启完成！"
            echo "Windows 11 Server 25H2 已重新启动"
            echo "现在可以使用所有功能了"
        else
            echo "用法: windows shutdown /r"
            echo "示例: windows shutdown /r"
        fi
        ;;
    "")
        check_installed
        check_reboot

        echo "Microsoft Windows [版本 11.0.25276]"
        echo "版权所有 (c) 2026 Microsoft Corporation。保留所有权利。"
        echo ""
        echo "本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆"
        echo ""

        while true; do
            echo -n "C:\Users\Administrator> "
            read cmd

            if [ "$cmd" = "exit" ]; then
                echo "正在退出交互模式..."
                break
            fi

            if [ -z "$cmd" ]; then
                continue
            fi

            cmd_name=$(echo "$cmd" | awk '{print $1}')
            cmd_args=$(echo "$cmd" | cut -d' ' -f2-)

            case "$cmd_name" in
                mkdir)
                    if [ -z "$cmd_args" ]; then
                        echo "用法: mkdir 目录名"
                    else
                        mkdir -p "$PHYSICAL_DIR/$cmd_args"
                        echo "目录已创建: $cmd_args"
                    fi
                    ;;
                echo)
                    eval "$cmd"
                    ;;
                ping)
                    eval "$cmd"
                    ;;
                *)
                    if [ -f "$HOME_DIR/C:/system32/$cmd_name" ]; then
                        echo "暂时未开发，请下个版本再试"
                    else
                        echo "'$cmd' 不是内部或外部命令，也不是可运行的程序"
                        echo "或批处理文件。"
                    fi
                    ;;
            esac
        done
        ;;
    *)
        echo "用法: windows {install|stop|version|uninstall|shutdown}"
        echo "示例: windows install"
        echo "直接输入 windows 进入交互模式"
        ;;
esac
