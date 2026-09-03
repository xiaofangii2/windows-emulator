#!/usr/bin/env bash
[ -d "/data/data/com.termux" ] && IS_TERMUX=1 || IS_TERMUX=0
HOME_DIR="$HOME/Windows11"
STOP_FILE="$HOME_DIR/stop"
[ "$IS_TERMUX" = "0" ] && STOP_FILE="/tmp/windows_stop"

mkdir -p ~/bin "$HOME_DIR" "$HOME_DIR/C:" "$HOME_DIR/C:/Windows/System32" "$HOME_DIR/C:/Users/Administrator" "$HOME_DIR/C:/Users/Public"
mkdir -p "$HOME_DIR/C:/Windows/System32/drivers" "$HOME_DIR/C:/Windows/System32/config" "$HOME_DIR/C:/Windows/System32/spool"
mkdir -p "$HOME_DIR/C:/Windows/Temp" "$HOME_DIR/C:/Windows/Logs" "$HOME_DIR/C:/Program Files" "$HOME_DIR/C:/Program Files (x86)"
mkdir -p "$HOME_DIR/C:/ProgramData" "$HOME_DIR/C:/PerfLogs"

[ ! -f "$HOME_DIR/status" ] && echo "false" > "$HOME_DIR/status"
[ ! -f "$HOME_DIR/reboot" ] && echo "false" > "$HOME_DIR/reboot"
[ ! -f "$HOME_DIR/oobe" ] && echo "false" > "$HOME_DIR/oobe"
[ ! -f "$HOME_DIR/C:/Windows/System32/config/password.hash" ] && mkdir -p "$HOME_DIR/C:/Windows/System32/config" && echo "" > "$HOME_DIR/C:/Windows/System32/config/password.hash"
[ ! -f "$HOME_DIR/username" ] && echo "Administrator" > "$HOME_DIR/username"

grep -q "export PATH=\$PATH:~/bin" ~/.bashrc 2>/dev/null || echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
cp "$0" ~/bin/windows 2>/dev/null && chmod +x ~/bin/windows

USERNAME=$(cat "$HOME_DIR/username" 2>/dev/null || echo "Administrator")
PHYSICAL_DIR="$HOME_DIR/C:/Users/$USERNAME"

check_openssl() {
    command -v openssl &> /dev/null || {
        echo ""; echo "错误：未找到 openssl 命令"; echo "请先安装 openssl："
        [ "$IS_TERMUX" = "1" ] && echo "  pkg install openssl" || echo "  sudo apt install openssl"
        exit 1
    }
}

check_password() {
    if [ -f "$HOME_DIR/C:/Windows/System32/config/password.hash" ] && [ -s "$HOME_DIR/C:/Windows/System32/config/password.hash" ]; then
        echo -n "请输入密码："; read -s user_pass; echo ""
        user_hash=$(echo -n "$user_pass" | openssl dgst -sha256 | awk '{print $2}')
        stored_hash=$(cat "$HOME_DIR/C:/Windows/System32/config/password.hash")
        if [ "$user_hash" != "$stored_hash" ]; then
            echo "密码错误！"; exit 1
        fi
    fi
}

check_installed() {
    [ ! -f "$HOME_DIR/status" ] || [ "$(cat "$HOME_DIR/status")" != "true" ] && {
        echo ""; echo "Segmentation fault (core dumped)"; echo "Error: Null pointer dereference"
        echo "File: src/windows.c"; echo "Line: 42"; echo "Process returned 139 (0x8B) execution time : 0.002 s"; exit 1
    }
}

check_reboot() {
    [ ! -f "$HOME_DIR/reboot" ] || [ "$(cat "$HOME_DIR/reboot")" != "true" ] && {
        echo ""; echo "Error: System requires reboot to complete installation"; echo "File: src/windows.c"; echo "Line: 56"
        echo "Please run 'windows shutdown /r' first"; echo "Process returned 1 (0x1) execution time : 0.001 s"; exit 1
    }
}

check_oobe() {
    [ ! -f "$HOME_DIR/oobe" ] || [ "$(cat "$HOME_DIR/oobe")" != "true" ] && {
        echo ""; echo "Error: OOBE not completed"; echo "File: src/windows.c"; echo "Line: 68"
        echo "Please run 'windows oobe' first"; echo "Process returned 1 (0x1) execution time : 0.001 s"; exit 1
    }
}

cmd_tasklist() {
    echo "映像名称                       PID  会话名     会话#       内存使用"
    echo "=========================  ====== ================ =========== ============"
    ps -eo comm=,pid=,tty=,time=,rss= 2>/dev/null | head -20 || ps aux | head -20
}

case $1 in
    install)
        check_openssl
        [ -f "$HOME_DIR/status" ] && [ "$(cat "$HOME_DIR/status")" = "true" ] && {
            echo ""; echo "Error: Installation already detected!"; echo "File: $HOME_DIR/status"; echo "Line: 42"
            echo "Process returned 1 (0x1) execution time : 0.003 s"; exit 1
        }

        if ! command -v unzip &> /dev/null; then
            echo "未找到 unzip，正在安装..."
            if [ "$IS_TERMUX" = "1" ]; then
                pkg install unzip -y
            else
                sudo apt update 2>/dev/null && sudo apt install unzip -y 2>/dev/null || echo "请手动安装 unzip"
            fi
        fi

        mkdir -p "$HOME_DIR/C:/Windows/Temp"
        echo "正在下载命令包..."
        COMMAND_URL="https://github.com/xiaofangii2/windows-emulator/releases/download/command-1.0.0/command.zip"
        TEMP_ZIP="$HOME_DIR/C:/Windows/Temp/command.zip"
        if curl -L -o "$TEMP_ZIP" "$COMMAND_URL" 2>/dev/null; then
            echo "正在解压命令包..."
            unzip -o "$TEMP_ZIP" -d "$HOME_DIR/C:/Windows/System32/" > /dev/null 2>&1
            rm -f "$TEMP_ZIP"
            chmod +x "$HOME_DIR/C:/Windows/System32/"*.exe 2>/dev/null
            echo "命令包安装成功"
        else
            echo "命令包下载失败，请稍后手动下载解压到 C:\\Windows\\System32"
        fi

        printf "\033[?25l"
        trap 'printf "\033[?25h"; exit' EXIT
        trap 'printf "\033[?25h"; echo ""; echo "安装已暂停"; exit' INT TERM
        echo "正在安装 Windows 11 Server..."
        echo ""
        echo "按 Ctrl+C 或输入 stop 暂停安装"
        echo ""
        for i in {1..20}; do
            [ -f "$STOP_FILE" ] && { rm -f "$STOP_FILE"; echo ""; echo "安装已暂停"; printf "\033[?25h"; exit 0; }
            printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5))
            sleep 0.5
        done
        echo ""
        echo "true" > "$HOME_DIR/status"
        echo "false" > "$HOME_DIR/reboot"
        echo "false" > "$HOME_DIR/oobe"
        echo "Administrator" > "$HOME_DIR/username"
        printf "\033[?25h"
        echo ""
        echo ""
        echo "安装完成！请重启系统。"
        echo "输入 windows shutdown /r 重启"
        ;;
    stop) touch "$STOP_FILE"; echo "正在暂停操作..." ;;
    version) check_installed; check_reboot; check_oobe; check_password; echo "Windows 11 Server 25H2" ;;
    uninstall)
        check_installed; check_reboot; check_oobe; check_password
        printf "\033[?25l"
        trap 'printf "\033[?25h"; exit' EXIT
        trap 'printf "\033[?25h"; echo ""; echo "操作已暂停"; exit' INT TERM
        echo "正在卸载 Windows 11 Server..."
        echo ""
        echo "按 Ctrl+C 或输入 stop 暂停卸载"
        echo ""
        for i in {1..20}; do
            [ -f "$STOP_FILE" ] && { rm -f "$STOP_FILE"; echo ""; echo "卸载已暂停"; printf "\033[?25h"; exit 0; }
            printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5))
            sleep 0.3
        done
        echo ""
        rm -rf "$HOME_DIR"
        printf "\033[?25h"
        echo ""
        echo ""
        echo "卸载完成！"
        echo "Windows 11 Server has been removed from your system."
        ;;
    shutdown)
        check_installed
        [ "$2" = "/r" ] || [ "$2" = "-r" ] && {
            echo "正在重启系统..."
            echo ""
            for i in {1..20}; do
                printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5))
                sleep 0.3
            done
            echo ""
            echo "true" > "$HOME_DIR/reboot"
            echo ""
            echo ""
            echo "重启完成！"
            echo "Windows 11 Server 25H2 已重新启动"
            echo "现在可以使用所有功能了"
        } || { echo "用法: windows shutdown /r"; echo "示例: windows shutdown /r"; }
        ;;
    oobe)
        check_installed; check_reboot; check_openssl
        [ -f "$HOME_DIR/oobe" ] && [ "$(cat "$HOME_DIR/oobe")" = "true" ] && {
            echo ""; echo "你的电脑遇到问题，需要重新启动。"; echo "我们只收集某些错误信息，然后为你重新启动。"; echo ""
            echo "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"; echo ""
            echo "停止代码：0x1000007E"; echo "参数 1：0xffffffffc0000005"; echo "参数 2：0xfffff803570cf08a"
            echo "参数 3：0xfffc1092c94f8f8"; echo "参数 4：0xfffff8035bc7e920"; echo ""
            echo "导致错误的驱动程序：ntoskrnl.exe"; echo "文件描述：NT Kernel & System"; echo "公司：Microsoft Corporation"
            echo "文件版本：10.0.19033.1 (WinBuild.160101.0800)"; echo "处理器：x64"; echo ""
            echo "转储文件保存于：C:\\Windows\\MEMORY.DMP"; echo "报告 ID：3c004115-c447-4b9a-83c6-903d2277f737"; echo ""
            echo "要了解有关此错误的更多信息，请搜索 \"SYSTEM_THREAD_EXCEPTION_NOT_HANDLED\""; exit 1
        }

        OOBE_LOG="$HOME_DIR/oobe_enter"
        echo "OOBE 设置记录 - $(date)" > "$OOBE_LOG"
        echo "-----------------------------" >> "$OOBE_LOG"

        echo ""; echo "Windows 11 Server OOBE 设置向导"; echo ""

        while true; do
            echo -n "地区："; read region
            [ -n "$region" ] && break
            echo "不能为空，请重新输入"
        done
        echo "地区: $region" >> "$OOBE_LOG"

        while true; do
            echo -n "键盘布局："; read keyboard
            [ -n "$keyboard" ] && break
            echo "不能为空，请重新输入"
        done
        echo "键盘布局: $keyboard" >> "$OOBE_LOG"

        while true; do
            echo -n "用户名："; read username
            [ -n "$username" ] && break
            echo "不能为空，请重新输入"
        done
        echo "用户名: $username" >> "$OOBE_LOG"
        echo "$username" > "$HOME_DIR/username"

        USER_DIR="$HOME_DIR/C:/Users/$username"
        mkdir -p "$USER_DIR"

        echo ""
        activation_status="未输入"
        while true; do
            echo -n "请输入激活码（留空表示没有）："
            read activation_key
            if [ -z "$activation_key" ]; then
                activation_status="未输入"
                echo "未输入激活码，跳过激活步骤"
                break
            fi
            echo "正在验证激活码..."
            response=$(curl -s "http://css.xiaofangii.dpdns.org:8080/verify?key=$activation_key")
            if echo "$response" | grep -q "true"; then
                activation_status="有效"
                echo "激活成功！"
                break
            else
                activation_status="无效"
                echo "激活码无效，请重新输入"
            fi
        done
        echo "激活码: $activation_status" >> "$OOBE_LOG"

        echo ""
        echo -n "设置密码："; read -s password; echo ""
        while [ -z "$password" ]; do echo "不能为空，请重新输入"; echo -n "设置密码："; read -s password; echo ""; done
        echo -n "$password" | openssl dgst -sha256 | awk '{print $2}' > "$HOME_DIR/C:/Windows/System32/config/password.hash"
        pwd_len=$(echo -n "$password" | wc -c)
        pwd_stars=$(printf "%${pwd_len}s" | tr " " "*")
        echo "密码: $pwd_stars" >> "$OOBE_LOG"
        echo "密码已设置。"; echo ""

        echo "许可条款："; echo "本软件仅供个人学习、研究使用，禁止任何形式的商业用途。"; echo "继续使用即表示您同意上述条款。"; echo ""
        while true; do echo -n "是否同意？(y/n)："; read agree; [ "$agree" = "y" ] && break; [ "$agree" = "n" ] && echo "" && echo "您拒绝了许可条款，OOBE 已取消。" && exit 0; echo "请输入 y 或 n"; done

        echo ""; echo "OOBE 完成！"; echo "正在进入系统..."; sleep 2; echo ""
        echo "true" > "$HOME_DIR/oobe"

        PHYSICAL_DIR="$HOME_DIR/C:/Users/$username"

        echo "Microsoft Windows [版本 11.0.25276]"; echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
        echo ""; echo "本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆"; echo ""

        while true; do
            echo -n "C:\\Users\\$username> "
            read cmd
            [ "$cmd" = "exit" ] && echo "正在退出交互模式..." && break
            [ -z "$cmd" ] && continue
            cmd_name=$(echo "$cmd" | awk '{print $1}')
            cmd_args=$(echo "$cmd" | cut -d' ' -f2-)

            cmd_name="${cmd_name%.exe}"

            if [ -f "$HOME_DIR/C:/Windows/System32/${cmd_name}.exe" ]; then
                "$HOME_DIR/C:/Windows/System32/${cmd_name}.exe" $cmd_args
            elif [ -f "$HOME_DIR/C:/Windows/System32/$cmd_name" ]; then
                "$HOME_DIR/C:/Windows/System32/$cmd_name" $cmd_args
            else
                echo "'$cmd' 不是内部或外部命令，也不是可运行的程序"
                echo "或批处理文件。"
            fi
        done
        ;;
    "")
        check_installed; check_reboot; check_oobe; check_password
        USERNAME=$(cat "$HOME_DIR/username" 2>/dev/null || echo "Administrator")
        PHYSICAL_DIR="$HOME_DIR/C:/Users/$USERNAME"

        echo "Microsoft Windows [版本 11.0.25276]"; echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
        echo ""; echo "本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆"; echo ""

        while true; do
            echo -n "C:\\Users\\$USERNAME> "
            read cmd
            [ "$cmd" = "exit" ] && echo "正在退出交互模式..." && break
            [ -z "$cmd" ] && continue
            cmd_name=$(echo "$cmd" | awk '{print $1}')
            cmd_args=$(echo "$cmd" | cut -d' ' -f2-)

            cmd_name="${cmd_name%.exe}"

            if [ -f "$HOME_DIR/C:/Windows/System32/${cmd_name}.exe" ]; then
                "$HOME_DIR/C:/Windows/System32/${cmd_name}.exe" $cmd_args
            elif [ -f "$HOME_DIR/C:/Windows/System32/$cmd_name" ]; then
                "$HOME_DIR/C:/Windows/System32/$cmd_name" $cmd_args
            else
                echo "'$cmd' 不是内部或外部命令，也不是可运行的程序"
                echo "或批处理文件。"
            fi
        done
        ;;
    *) echo "用法: windows {install|stop|version|uninstall|shutdown|oobe}"
        echo "  install      安装系统"; echo "  stop         暂停操作"; echo "  version      显示版本"
        echo "  uninstall    卸载系统"; echo "  shutdown /r  重启系统"; echo "  oobe         OOBE 设置向导"
        echo "直接输入 windows 进入交互模式" ;;
esac
