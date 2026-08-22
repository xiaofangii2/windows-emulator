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
mkdir -p "$HOME_DIR/C:/system32"

if [ ! -f "$HOME_DIR/status" ]; then
    echo "false" > "$HOME_DIR/status"
fi
if [ ! -f "$HOME_DIR/reboot" ]; then
    echo "false" > "$HOME_DIR/reboot"
fi
if [ ! -f "$HOME_DIR/oobe" ]; then
    echo "false" > "$HOME_DIR/oobe"
fi
if [ ! -f "$HOME_DIR/C:/system32/password.hash" ]; then
    echo "" > "$HOME_DIR/C:/system32/password.hash"
fi

if ! grep -q "export PATH=\$PATH:~/bin" ~/.bashrc 2>/dev/null; then
    echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
fi

cp "$0" ~/bin/windows 2>/dev/null
chmod +x ~/bin/windows

PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator"

check_openssl() {
    if ! command -v openssl &> /dev/null; then
        echo ""
        echo "错误：未找到 openssl 命令"
        echo "请先安装 openssl："
        if [ "$IS_TERMUX" = "1" ]; then
            echo "  pkg install openssl"
        else
            echo "  sudo apt install openssl  # Debian/Ubuntu"
            echo "  sudo yum install openssl  # CentOS/RHEL"
        fi
        exit 1
    fi
}

check_password() {
    if [ -f "$HOME_DIR/C:/system32/password.hash" ] && [ -s "$HOME_DIR/C:/system32/password.hash" ]; then
        echo -n "请输入密码："
        read -s user_pass
        echo ""
        user_hash=$(echo -n "$user_pass" | openssl dgst -sha256 | awk '{print $2}')
        stored_hash=$(cat "$HOME_DIR/C:/system32/password.hash")
        if [ "$user_hash" != "$stored_hash" ]; then
            echo "密码错误！"
            exit 1
        fi
    fi
}

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

check_oobe() {
    if [ ! -f "$HOME_DIR/oobe" ]; then
        echo ""
        echo "Error: OOBE not completed"
        echo "File: src/windows.c"
        echo "Line: 68"
        echo "Please run 'windows oobe' first"
        echo "Process returned 1 (0x1) execution time : 0.001 s"
        exit 1
    fi
    if [ "$(cat "$HOME_DIR/oobe")" != "true" ]; then
        echo ""
        echo "Error: OOBE not completed"
        echo "File: src/windows.c"
        echo "Line: 68"
        echo "Please run 'windows oobe' first"
        echo "Process returned 1 (0x1) execution time : 0.001 s"
        exit 1
    fi
}

case $1 in
    install)
        check_openssl

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
        echo "false" > "$HOME_DIR/oobe"

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
        check_oobe
        check_password
        echo "Windows 11 Server 25H2"
        ;;
    uninstall)
        check_installed
        check_reboot
        check_oobe
        check_password

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
        echo "false" > "$HOME_DIR/oobe"
        rm -f "$HOME_DIR/C:/system32/password.hash"

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
    oobe)
        check_installed
        check_reboot
        check_openssl

        if [ -f "$HOME_DIR/oobe" ] && [ "$(cat "$HOME_DIR/oobe")" = "true" ]; then
            echo ""
            echo "你的电脑遇到问题，需要重新启动。"
            echo "我们只收集某些错误信息，然后为你重新启动。"
            echo ""
            echo "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"
            echo ""
            echo "停止代码：0x1000007E"
            echo "参数 1：0xffffffffc0000005"
            echo "参数 2：0xfffff803570cf08a"
            echo "参数 3：0xfffc1092c94f8f8"
            echo "参数 4：0xfffff8035bc7e920"
            echo ""
            echo "导致错误的驱动程序：ntoskrnl.exe"
            echo "文件描述：NT Kernel & System"
            echo "公司：Microsoft Corporation"
            echo "文件版本：10.0.19033.1 (WinBuild.160101.0800)"
            echo "处理器：x64"
            echo ""
            echo "转储文件保存于：C:\\Windows\\MEMORY.DMP"
            echo "报告 ID：3c004115-c447-4b9a-83c6-903d2277f737"
            echo ""
            echo "要了解有关此错误的更多信息，请搜索 \"SYSTEM_THREAD_EXCEPTION_NOT_HANDLED\""
            exit 1
        fi

        echo ""
        echo "Windows 11 Server OOBE 设置向导"
        echo ""

        while true; do
            echo -n "地区："
            read region
            if [ -n "$region" ]; then
                break
            fi
            echo "地区不能为空，请重新输入"
        done

        while true; do
            echo -n "键盘布局："
            read keyboard
            if [ -n "$keyboard" ]; then
                break
            fi
            echo "键盘布局不能为空，请重新输入"
        done

        echo ""
        echo -n "设置密码："
        read -s password
        echo ""

        while [ -z "$password" ]; do
            echo "密码不能为空，请重新输入"
            echo -n "设置密码："
            read -s password
            echo ""
        done

        password_hash=$(echo -n "$password" | openssl dgst -sha256 | awk '{print $2}')
        echo "$password_hash" > "$HOME_DIR/C:/system32/password.hash"
        echo "密码已设置。"

        echo ""
        echo "许可条款："
        echo "本软件仅供个人学习、研究使用，禁止任何形式的商业用途。"
        echo "继续使用即表示您同意上述条款。"
        echo ""

        while true; do
            echo -n "是否同意？(y/n)："
            read agree
            if [ "$agree" = "y" ]; then
                break
            elif [ "$agree" = "n" ]; then
                echo ""
                echo "您拒绝了许可条款，OOBE 已取消。"
                exit 0
            else
                echo "请输入 y 或 n"
            fi
        done

        echo ""
        echo "OOBE 完成！"
        echo "正在进入系统..."
        sleep 2
        echo ""

        echo "true" > "$HOME_DIR/oobe"

        echo "Microsoft Windows [版本 11.0.25276]"
        echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
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
                dir)
                    ls -la "$PHYSICAL_DIR"
                    ;;
                cd)
                    if [ -z "$cmd_args" ]; then
                        PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator"
                    elif [ "$cmd_args" = ".." ]; then
                        PHYSICAL_DIR="$(dirname "$PHYSICAL_DIR")"
                    elif [ -d "$PHYSICAL_DIR/$cmd_args" ]; then
                        PHYSICAL_DIR="$PHYSICAL_DIR/$cmd_args"
                    else
                        echo "系统找不到指定的路径。"
                    fi
                    ;;
                cls)
                    clear
                    ;;
                ver)
                    echo "Microsoft Windows [版本 11.0.25276]"
                    ;;
                systeminfo)
                    echo "主机名:           $(hostname)"
                    echo "操作系统名称:     Microsoft Windows 11 Server 25H2"
                    echo "操作系统版本:     11.0.25276"
                    echo "制造商:           xiaofang"
                    echo "系统类型:         x64-based PC"
                    echo "处理器:           模拟 x64"
                    echo "物理内存:         $(free -m | awk '/^Mem:/{print $2}') MB"
                    echo "可用物理内存:     $(free -m | awk '/^Mem:/{print $4}') MB"
                    echo "虚拟内存:         $(free -m | awk '/^Swap:/{print $2}') MB"
                    echo "可用虚拟内存:     $(free -m | awk '/^Swap:/{print $4}') MB"
                    echo "安装时间:         $(stat -c %y "$HOME_DIR/status" 2>/dev/null || stat -f %Sm "$HOME_DIR/status" 2>/dev/null | cut -d. -f1)"
                    echo "系统目录:         $HOME_DIR/C:/system32"
                    echo "用户目录:         $PHYSICAL_DIR"
                    ;;
                help)
                    echo "Windows 11 Server 命令帮助："
                    echo ""
                    echo "  dir         显示当前目录内容"
                    echo "  cd          切换目录（cd .. 返回上级）"
                    echo "  mkdir       创建目录"
                    echo "  cls         清屏"
                    echo "  ver         显示版本信息"
                    echo "  systeminfo  显示系统信息"
                    echo "  echo        显示信息"
                    echo "  ping        测试网络连通性"
                    echo "  exit        退出交互模式"
                    echo ""
                    echo "更多命令正在开发中，请期待后续版本"
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
    "")
        check_installed
        check_reboot
        check_oobe
        check_password

        echo "Microsoft Windows [版本 11.0.25276]"
        echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
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
                dir)
                    ls -la "$PHYSICAL_DIR"
                    ;;
                cd)
                    if [ -z "$cmd_args" ]; then
                        PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator"
                    elif [ "$cmd_args" = ".." ]; then
                        PHYSICAL_DIR="$(dirname "$PHYSICAL_DIR")"
                    elif [ -d "$PHYSICAL_DIR/$cmd_args" ]; then
                        PHYSICAL_DIR="$PHYSICAL_DIR/$cmd_args"
                    else
                        echo "系统找不到指定的路径。"
                    fi
                    ;;
                cls)
                    clear
                    ;;
                ver)
                    echo "Microsoft Windows [版本 11.0.25276]"
                    ;;
                systeminfo)
                    echo "主机名:           $(hostname)"
                    echo "操作系统名称:     Microsoft Windows 11 Server 25H2"
                    echo "操作系统版本:     11.0.25276"
                    echo "制造商:           xiaofang"
                    echo "系统类型:         x64-based PC"
                    echo "处理器:           模拟 x64"
                    echo "物理内存:         $(free -m | awk '/^Mem:/{print $2}') MB"
                    echo "可用物理内存:     $(free -m | awk '/^Mem:/{print $4}') MB"
                    echo "虚拟内存:         $(free -m | awk '/^Swap:/{print $2}') MB"
                    echo "可用虚拟内存:     $(free -m | awk '/^Swap:/{print $4}') MB"
                    echo "安装时间:         $(stat -c %y "$HOME_DIR/status" 2>/dev/null || stat -f %Sm "$HOME_DIR/status" 2>/dev/null | cut -d. -f1)"
                    echo "系统目录:         $HOME_DIR/C:/system32"
                    echo "用户目录:         $PHYSICAL_DIR"
                    ;;
                help)
                    echo "Windows 11 Server 命令帮助："
                    echo ""
                    echo "  dir         显示当前目录内容"
                    echo "  cd          切换目录（cd .. 返回上级）"
                    echo "  mkdir       创建目录"
                    echo "  cls         清屏"
                    echo "  ver         显示版本信息"
                    echo "  systeminfo  显示系统信息"
                    echo "  echo        显示信息"
                    echo "  ping        测试网络连通性"
                    echo "  exit        退出交互模式"
                    echo ""
                    echo "更多命令正在开发中，请期待后续版本"
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
        echo "用法: windows {install|stop|version|uninstall|shutdown|oobe}"
        echo "示例: windows install"
        echo "直接输入 windows 进入交互模式"
        ;;
esac
