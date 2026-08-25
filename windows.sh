#!/usr/bin/env bash

# ========== 检测系统 ==========
[ -d "/data/data/com.termux" ] && IS_TERMUX=1 || IS_TERMUX=0
HOME_DIR="$HOME/Windows11"
STOP_FILE="$HOME_DIR/stop"
[ "$IS_TERMUX" = "0" ] && STOP_FILE="/tmp/windows_stop"

# ========== 语言包 ==========
LANG_DIR="$HOME/.windows-lang"
mkdir -p "$LANG_DIR"
[ -f "$LANG_DIR/lang.conf" ] && CURRENT_LANG=$(cat "$LANG_DIR/lang.conf") || CURRENT_LANG="zh-CN"

load_lang() { source "$LANG_DIR/$1.lang" 2>/dev/null || source "$LANG_DIR/zh-CN.lang"; }

if [ ! -f "$LANG_DIR/zh-CN.lang" ]; then
cat > "$LANG_DIR/zh-CN.lang" << 'LANGEOF'
LANG_NAME="简体中文"
MSG_INSTALL_TITLE="正在安装 Windows 11 Server..."
MSG_INSTALL_PAUSE="按 Ctrl+C 或输入 stop 暂停安装"
MSG_INSTALL_PAUSED="安装已暂停"
MSG_INSTALL_COMPLETE="安装完成！请重启系统。"
MSG_INSTALL_REBOOT="输入 windows shutdown /r 重启"
MSG_REBOOT_TITLE="正在重启系统..."
MSG_REBOOT_COMPLETE="重启完成！"
MSG_REBOOT_READY="Windows 11 Server 25H2 已重新启动"
MSG_REBOOT_NOW="现在可以使用所有功能了"
MSG_OOBE_TITLE="Windows 11 Server OOBE 设置向导"
MSG_OOBE_REGION="地区："
MSG_OOBE_KEYBOARD="键盘布局："
MSG_OOBE_PASSWORD="设置密码："
MSG_OOBE_EMPTY="密码不能为空，请重新输入"
MSG_OOBE_LICENSE="许可条款："
MSG_OOBE_TERMS="本软件仅供个人学习、研究使用，禁止任何形式的商业用途。"
MSG_OOBE_CONTINUE="继续使用即表示您同意上述条款。"
MSG_OOBE_AGREE="是否同意？(y/n)："
MSG_OOBE_AGREED="密码已设置。"
MSG_OOBE_DENIED="您拒绝了许可条款，OOBE 已取消。"
MSG_OOBE_COMPLETE="OOBE 完成！"
MSG_OOBE_ENTER="正在进入系统..."
MSG_LOGIN_PASSWORD="请输入密码："
MSG_ACTIVATION_PROMPT="请输入激活码（留空表示没有）："
MSG_ACTIVATION_VERIFY="正在验证激活码..."
MSG_ACTIVATION_SUCCESS="激活成功！"
MSG_ACTIVATION_ERROR="激活码无效，请重新输入"
MSG_ACTIVATION_SKIP="未输入激活码，跳过激活步骤"
MSG_CMD_PROMPT="C:\\Users\\Administrator> "
MSG_CMD_NOT_FOUND="不是内部或外部命令，也不是可运行的程序"
MSG_CMD_UNKNOWN="或批处理文件。"
MSG_CMD_NODEV="暂时未开发，请下个版本再试"
MSG_CMD_MKDIR_USAGE="用法: mkdir 目录名"
MSG_CMD_MKDIR_CREATED="目录已创建"
MSG_CMD_CD_NOTFOUND="系统找不到指定的路径。"
MSG_CMD_TYPE_USAGE="用法: type 文件名"
MSG_CMD_FIND_USAGE="用法: find \"文本\" 文件名"
MSG_ERROR_SEGFAULT="Segmentation fault (core dumped)"
MSG_ERROR_NULL="Error: Null pointer dereference"
MSG_ERROR_REBOOT="Error: System requires reboot to complete installation"
MSG_ERROR_OOBE="Error: OOBE not completed"
MSG_ERROR_INSTALLED="Error: Installation already detected!"
MSG_ERROR_OOBE_DONE="Error: OOBE already completed!"
MSG_ERROR_PASSWORD="密码错误！"
MSG_HELP_TITLE="Windows 11 Server 命令帮助："
MSG_HELP_CMDS="  dir         显示当前目录内容"
MSG_HELP_CD="  cd          切换目录（cd .. 返回上级）"
MSG_HELP_MKDIR="  mkdir       创建目录"
MSG_HELP_CLS="  cls         清屏"
MSG_HELP_VER="  ver         显示版本信息"
MSG_HELP_SYSTEMINFO="  systeminfo  显示系统信息"
MSG_HELP_ECHO="  echo        显示信息"
MSG_HELP_PING="  ping        测试网络连通性"
MSG_HELP_TYPE="  type        显示文件内容"
MSG_HELP_FIND="  find        在文件中搜索文本"
MSG_HELP_TASKLIST="  tasklist    显示进程列表"
MSG_HELP_WHOAMI="  whoami      显示当前用户"
MSG_HELP_HOSTNAME="  hostname    显示主机名"
MSG_HELP_DATE="  date        显示当前日期"
MSG_HELP_TIME="  time        显示当前时间"
MSG_HELP_EXIT="  exit        退出交互模式"
MSG_HELP_MORE="更多命令正在开发中，请期待后续版本"
MSG_BLUE_SCREEN="你的电脑遇到问题，需要重新启动。"
MSG_BLUE_SCREEN_2="我们只收集某些错误信息，然后为你重新启动。"
MSG_BLUE_ERROR="SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"
MSG_BLUE_CODE="停止代码：0x1000007E"
MSG_BLUE_PARAM1="参数 1：0xffffffffc0000005"
MSG_BLUE_PARAM2="参数 2：0xfffff803570cf08a"
MSG_BLUE_PARAM3="参数 3：0xfffc1092c94f8f8"
MSG_BLUE_PARAM4="参数 4：0xfffff8035bc7e920"
MSG_BLUE_DRIVER="导致错误的驱动程序：ntoskrnl.exe"
MSG_BLUE_DESC="文件描述：NT Kernel & System"
MSG_BLUE_COMPANY="公司：Microsoft Corporation"
MSG_BLUE_VERSION="文件版本：10.0.19033.1 (WinBuild.160101.0800)"
MSG_BLUE_PROCESSOR="处理器：x64"
MSG_BLUE_DUMP="转储文件保存于：C:\\Windows\\MEMORY.DMP"
MSG_BLUE_REPORT="报告 ID：3c004115-c447-4b9a-83c6-903d2277f737"
MSG_BLUE_SEARCH="要了解有关此错误的更多信息，请搜索"
LANGEOF
fi

if [ ! -f "$LANG_DIR/en-US.lang" ]; then
cat > "$LANG_DIR/en-US.lang" << 'LANGEOF'
LANG_NAME="English"
MSG_INSTALL_TITLE="Installing Windows 11 Server..."
MSG_INSTALL_PAUSE="Press Ctrl+C or type stop to pause installation"
MSG_INSTALL_PAUSED="Installation paused"
MSG_INSTALL_COMPLETE="Installation complete! Please restart the system."
MSG_INSTALL_REBOOT="Type windows shutdown /r to restart"
MSG_REBOOT_TITLE="Restarting system..."
MSG_REBOOT_COMPLETE="Restart complete!"
MSG_REBOOT_READY="Windows 11 Server 25H2 has been restarted"
MSG_REBOOT_NOW="All features are now available"
MSG_OOBE_TITLE="Windows 11 Server OOBE Setup Wizard"
MSG_OOBE_REGION="Region: "
MSG_OOBE_KEYBOARD="Keyboard layout: "
MSG_OOBE_PASSWORD="Set password: "
MSG_OOBE_EMPTY="Password cannot be empty, please re-enter"
MSG_OOBE_LICENSE="License Terms:"
MSG_OOBE_TERMS="This software is for personal learning and research use only. Commercial use is prohibited."
MSG_OOBE_CONTINUE="Continuing indicates your agreement to the above terms."
MSG_OOBE_AGREE="Do you agree? (y/n): "
MSG_OOBE_AGREED="Password has been set."
MSG_OOBE_DENIED="You declined the license terms. OOBE cancelled."
MSG_OOBE_COMPLETE="OOBE complete!"
MSG_OOBE_ENTER="Entering system..."
MSG_LOGIN_PASSWORD="Enter password: "
MSG_ACTIVATION_PROMPT="Enter activation key (leave blank to skip): "
MSG_ACTIVATION_VERIFY="Verifying activation key..."
MSG_ACTIVATION_SUCCESS="Activation successful!"
MSG_ACTIVATION_ERROR="Invalid activation key, please try again"
MSG_ACTIVATION_SKIP="No activation key entered, skipping activation"
MSG_CMD_PROMPT="C:\\Users\\Administrator> "
MSG_CMD_NOT_FOUND="is not recognized as an internal or external command"
MSG_CMD_UNKNOWN="operable program or batch file."
MSG_CMD_NODEV="Not yet developed, please try in the next version"
MSG_CMD_MKDIR_USAGE="Usage: mkdir directory_name"
MSG_CMD_MKDIR_CREATED="Directory created"
MSG_CMD_CD_NOTFOUND="The system cannot find the path specified."
MSG_CMD_TYPE_USAGE="Usage: type filename"
MSG_CMD_FIND_USAGE="Usage: find \"text\" filename"
MSG_ERROR_SEGFAULT="Segmentation fault (core dumped)"
MSG_ERROR_NULL="Error: Null pointer dereference"
MSG_ERROR_REBOOT="Error: System requires reboot to complete installation"
MSG_ERROR_OOBE="Error: OOBE not completed"
MSG_ERROR_INSTALLED="Error: Installation already detected!"
MSG_ERROR_OOBE_DONE="Error: OOBE already completed!"
MSG_ERROR_PASSWORD="Password error!"
MSG_HELP_TITLE="Windows 11 Server Command Help:"
MSG_HELP_CMDS="  dir         Display current directory contents"
MSG_HELP_CD="  cd          Change directory (cd .. goes back)"
MSG_HELP_MKDIR="  mkdir       Create directory"
MSG_HELP_CLS="  cls         Clear screen"
MSG_HELP_VER="  ver         Display version information"
MSG_HELP_SYSTEMINFO="  systeminfo  Display system information"
MSG_HELP_ECHO="  echo        Display message"
MSG_HELP_PING="  ping        Test network connectivity"
MSG_HELP_TYPE="  type        Display file contents"
MSG_HELP_FIND="  find        Search for text in files"
MSG_HELP_TASKLIST="  tasklist    Display process list"
MSG_HELP_WHOAMI="  whoami      Display current user"
MSG_HELP_HOSTNAME="  hostname    Display hostname"
MSG_HELP_DATE="  date        Display current date"
MSG_HELP_TIME="  time        Display current time"
MSG_HELP_EXIT="  exit        Exit interactive mode"
MSG_HELP_MORE="More commands are under development, please stay tuned"
MSG_BLUE_SCREEN="Your PC ran into a problem and needs to restart."
MSG_BLUE_SCREEN_2="We're just collecting some error info, and then we'll restart for you."
MSG_BLUE_ERROR="SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"
MSG_BLUE_CODE="Stop code: 0x1000007E"
MSG_BLUE_PARAM1="Parameter 1: 0xffffffffc0000005"
MSG_BLUE_PARAM2="Parameter 2: 0xfffff803570cf08a"
MSG_BLUE_PARAM3="Parameter 3: 0xfffc1092c94f8f8"
MSG_BLUE_PARAM4="Parameter 4: 0xfffff8035bc7e920"
MSG_BLUE_DRIVER="Driver causing error: ntoskrnl.exe"
MSG_BLUE_DESC="File description: NT Kernel & System"
MSG_BLUE_COMPANY="Company: Microsoft Corporation"
MSG_BLUE_VERSION="File version: 10.0.19033.1 (WinBuild.160101.0800)"
MSG_BLUE_PROCESSOR="Processor: x64"
MSG_BLUE_DUMP="Dump file saved in: C:\\Windows\\MEMORY.DMP"
MSG_BLUE_REPORT="Report ID: 3c004115-c447-4b9a-83c6-903d2277f737"
MSG_BLUE_SEARCH="For more information about this error, search"
LANGEOF
fi

if [ ! -f "$LANG_DIR/zh-TW.lang" ]; then
cat > "$LANG_DIR/zh-TW.lang" << 'LANGEOF'
LANG_NAME="繁體中文"
MSG_INSTALL_TITLE="正在安裝 Windows 11 Server..."
MSG_INSTALL_PAUSE="按 Ctrl+C 或輸入 stop 暫停安裝"
MSG_INSTALL_PAUSED="安裝已暫停"
MSG_INSTALL_COMPLETE="安裝完成！請重啟系統。"
MSG_INSTALL_REBOOT="輸入 windows shutdown /r 重啟"
MSG_REBOOT_TITLE="正在重啟系統..."
MSG_REBOOT_COMPLETE="重啟完成！"
MSG_REBOOT_READY="Windows 11 Server 25H2 已重新啟動"
MSG_REBOOT_NOW="現在可以使用所有功能了"
MSG_OOBE_TITLE="Windows 11 Server OOBE 設定精靈"
MSG_OOBE_REGION="地區："
MSG_OOBE_KEYBOARD="鍵盤配置："
MSG_OOBE_PASSWORD="設定密碼："
MSG_OOBE_EMPTY="密碼不能為空，請重新輸入"
MSG_OOBE_LICENSE="授權條款："
MSG_OOBE_TERMS="本軟體僅供個人學習、研究使用，禁止任何形式的商業用途。"
MSG_OOBE_CONTINUE="繼續使用即表示您同意上述條款。"
MSG_OOBE_AGREE="是否同意？(y/n)："
MSG_OOBE_AGREED="密碼已設定。"
MSG_OOBE_DENIED="您拒絕了授權條款，OOBE 已取消。"
MSG_OOBE_COMPLETE="OOBE 完成！"
MSG_OOBE_ENTER="正在進入系統..."
MSG_LOGIN_PASSWORD="請輸入密碼："
MSG_ACTIVATION_PROMPT="請輸入啟用碼（留空表示沒有）："
MSG_ACTIVATION_VERIFY="正在驗證啟用碼..."
MSG_ACTIVATION_SUCCESS="啟用成功！"
MSG_ACTIVATION_ERROR="啟用碼無效，請重新輸入"
MSG_ACTIVATION_SKIP="未輸入啟用碼，跳過啟用步驟"
MSG_CMD_PROMPT="C:\\Users\\Administrator> "
MSG_CMD_NOT_FOUND="不是內部或外部命令，也不是可執行的程式"
MSG_CMD_UNKNOWN="或批次檔。"
MSG_CMD_NODEV="暫時未開發，請下個版本再試"
MSG_CMD_MKDIR_USAGE="用法: mkdir 目錄名"
MSG_CMD_MKDIR_CREATED="目錄已建立"
MSG_CMD_CD_NOTFOUND="系統找不到指定的路徑。"
MSG_CMD_TYPE_USAGE="用法: type 檔案名"
MSG_CMD_FIND_USAGE="用法: find \"文字\" 檔案名"
MSG_ERROR_SEGFAULT="Segmentation fault (core dumped)"
MSG_ERROR_NULL="Error: Null pointer dereference"
MSG_ERROR_REBOOT="Error: System requires reboot to complete installation"
MSG_ERROR_OOBE="Error: OOBE not completed"
MSG_ERROR_INSTALLED="Error: Installation already detected!"
MSG_ERROR_OOBE_DONE="Error: OOBE already completed!"
MSG_ERROR_PASSWORD="密碼錯誤！"
MSG_HELP_TITLE="Windows 11 Server 命令說明："
MSG_HELP_CMDS="  dir         顯示目前目錄內容"
MSG_HELP_CD="  cd          切換目錄（cd .. 返回上層）"
MSG_HELP_MKDIR="  mkdir       建立目錄"
MSG_HELP_CLS="  cls         清除畫面"
MSG_HELP_VER="  ver         顯示版本資訊"
MSG_HELP_SYSTEMINFO="  systeminfo  顯示系統資訊"
MSG_HELP_ECHO="  echo        顯示訊息"
MSG_HELP_PING="  ping        測試網路連線"
MSG_HELP_TYPE="  type        顯示檔案內容"
MSG_HELP_FIND="  find        在檔案中搜尋文字"
MSG_HELP_TASKLIST="  tasklist    顯示處理程序清單"
MSG_HELP_WHOAMI="  whoami      顯示目前使用者"
MSG_HELP_HOSTNAME="  hostname    顯示主機名稱"
MSG_HELP_DATE="  date        顯示目前日期"
MSG_HELP_TIME="  time        顯示目前時間"
MSG_HELP_EXIT="  exit        結束互動模式"
MSG_HELP_MORE="更多命令正在開發中，請期待後續版本"
MSG_BLUE_SCREEN="您的電腦發生問題，需要重新啟動。"
MSG_BLUE_SCREEN_2="我們只會收集某些錯誤資訊，然後為您重新啟動。"
MSG_BLUE_ERROR="SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"
MSG_BLUE_CODE="停止代碼：0x1000007E"
MSG_BLUE_PARAM1="參數 1：0xffffffffc0000005"
MSG_BLUE_PARAM2="參數 2：0xfffff803570cf08a"
MSG_BLUE_PARAM3="參數 3：0xfffc1092c94f8f8"
MSG_BLUE_PARAM4="參數 4：0xfffff8035bc7e920"
MSG_BLUE_DRIVER="導致錯誤的驅動程式：ntoskrnl.exe"
MSG_BLUE_DESC="檔案描述：NT Kernel & System"
MSG_BLUE_COMPANY="公司：Microsoft Corporation"
MSG_BLUE_VERSION="檔案版本：10.0.19033.1 (WinBuild.160101.0800)"
MSG_BLUE_PROCESSOR="處理器：x64"
MSG_BLUE_DUMP="傾印檔案儲存於：C:\\Windows\\MEMORY.DMP"
MSG_BLUE_REPORT="報告 ID：3c004115-c447-4b9a-83c6-903d2277f737"
MSG_BLUE_SEARCH="若要深入瞭解此錯誤，請搜尋"
LANGEOF
fi

if [ ! -f "$LANG_DIR/ja-JP.lang" ]; then
cat > "$LANG_DIR/ja-JP.lang" << 'LANGEOF'
LANG_NAME="日本語"
MSG_INSTALL_TITLE=""
MSG_INSTALL_PAUSE=""
MSG_INSTALL_PAUSED=""
MSG_INSTALL_COMPLETE=""
MSG_INSTALL_REBOOT=""
MSG_REBOOT_TITLE=""
MSG_REBOOT_COMPLETE=""
MSG_REBOOT_READY=""
MSG_REBOOT_NOW=""
MSG_OOBE_TITLE=""
MSG_OOBE_REGION=""
MSG_OOBE_KEYBOARD=""
MSG_OOBE_PASSWORD=""
MSG_OOBE_EMPTY=""
MSG_OOBE_LICENSE=""
MSG_OOBE_TERMS=""
MSG_OOBE_CONTINUE=""
MSG_OOBE_AGREE=""
MSG_OOBE_AGREED=""
MSG_OOBE_DENIED=""
MSG_OOBE_COMPLETE=""
MSG_OOBE_ENTER=""
MSG_LOGIN_PASSWORD=""
MSG_ACTIVATION_PROMPT=""
MSG_ACTIVATION_VERIFY=""
MSG_ACTIVATION_SUCCESS=""
MSG_ACTIVATION_ERROR=""
MSG_ACTIVATION_SKIP=""
MSG_CMD_PROMPT=""
MSG_CMD_NOT_FOUND=""
MSG_CMD_UNKNOWN=""
MSG_CMD_NODEV=""
MSG_CMD_MKDIR_USAGE=""
MSG_CMD_MKDIR_CREATED=""
MSG_CMD_CD_NOTFOUND=""
MSG_CMD_TYPE_USAGE=""
MSG_CMD_FIND_USAGE=""
MSG_ERROR_SEGFAULT=""
MSG_ERROR_NULL=""
MSG_ERROR_REBOOT=""
MSG_ERROR_OOBE=""
MSG_ERROR_INSTALLED=""
MSG_ERROR_OOBE_DONE=""
MSG_ERROR_PASSWORD=""
MSG_HELP_TITLE=""
MSG_HELP_CMDS=""
MSG_HELP_CD=""
MSG_HELP_MKDIR=""
MSG_HELP_CLS=""
MSG_HELP_VER=""
MSG_HELP_SYSTEMINFO=""
MSG_HELP_ECHO=""
MSG_HELP_PING=""
MSG_HELP_TYPE=""
MSG_HELP_FIND=""
MSG_HELP_TASKLIST=""
MSG_HELP_WHOAMI=""
MSG_HELP_HOSTNAME=""
MSG_HELP_DATE=""
MSG_HELP_TIME=""
MSG_HELP_EXIT=""
MSG_HELP_MORE=""
MSG_BLUE_SCREEN=""
MSG_BLUE_SCREEN_2=""
MSG_BLUE_ERROR=""
MSG_BLUE_CODE=""
MSG_BLUE_PARAM1=""
MSG_BLUE_PARAM2=""
MSG_BLUE_PARAM3=""
MSG_BLUE_PARAM4=""
MSG_BLUE_DRIVER=""
MSG_BLUE_DESC=""
MSG_BLUE_COMPANY=""
MSG_BLUE_VERSION=""
MSG_BLUE_PROCESSOR=""
MSG_BLUE_DUMP=""
MSG_BLUE_REPORT=""
MSG_BLUE_SEARCH=""
LANGEOF
fi

[ -f "$LANG_DIR/lang.conf" ] || echo "zh-CN" > "$LANG_DIR/lang.conf"
load_lang "$CURRENT_LANG"

mkdir -p ~/bin "$HOME_DIR" "$HOME_DIR/C:" "$HOME_DIR/C:/Windows/System32" "$HOME_DIR/C:/Users/Administrator" "$HOME_DIR/C:/Users/Public"
mkdir -p "$HOME_DIR/C:/Windows/System32/drivers" "$HOME_DIR/C:/Windows/System32/config" "$HOME_DIR/C:/Windows/System32/spool"
mkdir -p "$HOME_DIR/C:/Windows/Temp" "$HOME_DIR/C:/Windows/Logs" "$HOME_DIR/C:/Program Files" "$HOME_DIR/C:/Program Files (x86)"
mkdir -p "$HOME_DIR/C:/ProgramData" "$HOME_DIR/C:/PerfLogs"

[ ! -f "$HOME_DIR/status" ] && echo "false" > "$HOME_DIR/status"
[ ! -f "$HOME_DIR/reboot" ] && echo "false" > "$HOME_DIR/reboot"
[ ! -f "$HOME_DIR/oobe" ] && echo "false" > "$HOME_DIR/oobe"
[ ! -f "$HOME_DIR/C:/Windows/System32/password.hash" ] && echo "" > "$HOME_DIR/C:/Windows/System32/password.hash"

grep -q "export PATH=\$PATH:~/bin" ~/.bashrc 2>/dev/null || echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
cp "$0" ~/bin/windows 2>/dev/null && chmod +x ~/bin/windows

PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator"

check_openssl() {
    command -v openssl &> /dev/null || {
        echo ""; echo "错误：未找到 openssl 命令"; echo "请先安装 openssl："
        [ "$IS_TERMUX" = "1" ] && echo "  pkg install openssl" || echo "  sudo apt install openssl"
        exit 1
    }
}

check_password() {
    [ -f "$HOME_DIR/C:/Windows/System32/password.hash" ] && [ -s "$HOME_DIR/C:/Windows/System32/password.hash" ] && {
        echo -n "$MSG_LOGIN_PASSWORD"; read -s user_pass; echo ""
        [ "$(echo -n "$user_pass" | openssl dgst -sha256 | awk '{print $2}')" != "$(cat "$HOME_DIR/C:/Windows/System32/password.hash")" ] && {
            echo "$MSG_ERROR_PASSWORD"; exit 1
        }
    }
}

check_installed() {
    [ ! -f "$HOME_DIR/status" ] || [ "$(cat "$HOME_DIR/status")" != "true" ] && {
        echo ""; echo "$MSG_ERROR_SEGFAULT"; echo "$MSG_ERROR_NULL"
        echo "File: src/windows.c"; echo "Line: 42"; echo "Process returned 139 (0x8B) execution time : 0.002 s"; exit 1
    }
}

check_reboot() {
    [ ! -f "$HOME_DIR/reboot" ] || [ "$(cat "$HOME_DIR/reboot")" != "true" ] && {
        echo ""; echo "$MSG_ERROR_REBOOT"; echo "File: src/windows.c"; echo "Line: 56"
        echo "Please run 'windows shutdown /r' first"; echo "Process returned 1 (0x1) execution time : 0.001 s"; exit 1
    }
}

check_oobe() {
    [ ! -f "$HOME_DIR/oobe" ] || [ "$(cat "$HOME_DIR/oobe")" != "true" ] && {
        echo ""; echo "$MSG_ERROR_OOBE"; echo "File: src/windows.c"; echo "Line: 68"
        echo "Please run 'windows oobe' first"; echo "Process returned 1 (0x1) execution time : 0.001 s"; exit 1
    }
}

cmd_type() {
    [ -f "$1" ] && cat "$1" || echo "$MSG_CMD_CD_NOTFOUND"
}

cmd_find() {
    [ -f "$2" ] && grep "$1" "$2" || echo "$MSG_CMD_CD_NOTFOUND"
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
            echo ""; echo "$MSG_ERROR_INSTALLED"; echo "File: $HOME_DIR/status"; echo "Line: 42"
            echo "Process returned 1 (0x1) execution time : 0.003 s"; exit 1
        }
        echo -e "\033[?25l"
        trap 'echo -e "\033[?25h"; exit' EXIT
        trap 'echo -e "\033[?25h"; echo ""; echo "$MSG_INSTALL_PAUSED"; exit' INT TERM
        echo "$MSG_INSTALL_TITLE"; echo ""; echo "$MSG_INSTALL_PAUSE"; echo ""
        for i in {1..20}; do
            [ -f "$STOP_FILE" ] && { rm -f "$STOP_FILE"; echo ""; echo "$MSG_INSTALL_PAUSED"; echo -e "\033[?25h"; exit 0; }
            printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5)); sleep 0.5
        done
        touch "$HOME_DIR/C:/Windows/System32"/{dir,ping,ipconfig,tracert,netstat,tasklist,shutdown,systeminfo,ver,help,cls,exit,echo,mkdir,rmdir,del,copy,move,ren,type,find,taskkill,reg,sc,msconfig,whoami,hostname,date,time}
        echo "true" > "$HOME_DIR/status"; echo "false" > "$HOME_DIR/reboot"; echo "false" > "$HOME_DIR/oobe"
        echo -e "\033[?25h"; echo ""; echo ""; echo "$MSG_INSTALL_COMPLETE"; echo "$MSG_INSTALL_REBOOT"
        ;;
    stop) touch "$STOP_FILE"; echo "正在暂停操作..." ;;
    version) check_installed; check_reboot; check_oobe; check_password; echo "Windows 11 Server 25H2" ;;
    uninstall)
        check_installed; check_reboot; check_oobe; check_password
        echo -e "\033[?25l"; trap 'echo -e "\033[?25h"; exit' EXIT
        trap 'echo -e "\033[?25h"; echo ""; echo "操作已暂停"; exit' INT TERM
        echo "正在卸载 Windows 11 Server..."; echo ""; echo "按 Ctrl+C 或输入 stop 暂停卸载"; echo ""
        for i in {1..20}; do
            [ -f "$STOP_FILE" ] && { rm -f "$STOP_FILE"; echo ""; echo "卸载已暂停"; echo -e "\033[?25h"; exit 0; }
            printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5)); sleep 0.3
        done
        echo "false" > "$HOME_DIR/status"; echo "false" > "$HOME_DIR/reboot"; echo "false" > "$HOME_DIR/oobe"
        rm -f "$HOME_DIR/C:/Windows/System32/password.hash"
        echo -e "\033[?25h"; echo ""; echo ""; echo "卸载完成！"; echo "Windows 11 Server has been removed from your system."
        ;;
    shutdown)
        check_installed
        [ "$2" = "/r" ] || [ "$2" = "-r" ] && {
            echo "$MSG_REBOOT_TITLE"; echo ""
            for i in {1..20}; do printf "\r%s %d%%" "$(printf '%0.s█' $(seq 1 $i))" $((i*5)); sleep 0.3; done
            echo "true" > "$HOME_DIR/reboot"
            echo ""; echo ""; echo "$MSG_REBOOT_COMPLETE"; echo "$MSG_REBOOT_READY"; echo "$MSG_REBOOT_NOW"
        } || { echo "用法: windows shutdown /r"; echo "示例: windows shutdown /r"; }
        ;;
    oobe)
        check_installed; check_reboot; check_openssl
        [ -f "$HOME_DIR/oobe" ] && [ "$(cat "$HOME_DIR/oobe")" = "true" ] && {
            echo ""; echo "$MSG_BLUE_SCREEN"; echo "$MSG_BLUE_SCREEN_2"; echo ""
            echo "$MSG_BLUE_ERROR"; echo ""; echo "$MSG_BLUE_CODE"; echo "$MSG_BLUE_PARAM1"
            echo "$MSG_BLUE_PARAM2"; echo "$MSG_BLUE_PARAM3"; echo "$MSG_BLUE_PARAM4"; echo ""
            echo "$MSG_BLUE_DRIVER"; echo "$MSG_BLUE_DESC"; echo "$MSG_BLUE_COMPANY"
            echo "$MSG_BLUE_VERSION"; echo "$MSG_BLUE_PROCESSOR"; echo ""
            echo "$MSG_BLUE_DUMP"; echo "$MSG_BLUE_REPORT"; echo ""
            echo "$MSG_BLUE_SEARCH \"$MSG_BLUE_ERROR\""; exit 1
        }

        # 创建日志文件
        OOBE_LOG="$HOME_DIR/oobe_enter"
        echo "OOBE 设置记录 - $(date)" > "$OOBE_LOG"
        echo "-----------------------------" >> "$OOBE_LOG"

        echo ""; echo "$MSG_OOBE_TITLE"; echo ""
        while true; do
            echo -n "$MSG_OOBE_REGION"
            read region
            [ -n "$region" ] && break
            echo "$MSG_OOBE_EMPTY"
        done
        echo "地区: $region" >> "$OOBE_LOG"

        while true; do
            echo -n "$MSG_OOBE_KEYBOARD"
            read keyboard
            [ -n "$keyboard" ] && break
            echo "$MSG_OOBE_EMPTY"
        done
        echo "键盘布局: $keyboard" >> "$OOBE_LOG"

        echo ""
        activation_status="未输入"
        while true; do
            echo -n "$MSG_ACTIVATION_PROMPT"
            read activation_key
            if [ -z "$activation_key" ]; then
                activation_status="未输入"
                echo "$MSG_ACTIVATION_SKIP"
                break
            fi
            echo "$MSG_ACTIVATION_VERIFY"
            response=$(curl -s "http://css.xiaofangii.dpdns.org:8080/verify?key=$activation_key")
            if echo "$response" | grep -q "true"; then
                activation_status="有效"
                echo "$MSG_ACTIVATION_SUCCESS"
                break
            else
                activation_status="无效"
                echo "$MSG_ACTIVATION_ERROR"
                # 继续循环
            fi
        done
        echo "激活码: $activation_status" >> "$OOBE_LOG"

        echo ""
        echo -n "$MSG_OOBE_PASSWORD"; read -s password; echo ""
        while [ -z "$password" ]; do echo "$MSG_OOBE_EMPTY"; echo -n "$MSG_OOBE_PASSWORD"; read -s password; echo ""; done
        echo -n "$password" | openssl dgst -sha256 | awk '{print $2}' > "$HOME_DIR/C:/Windows/System32/password.hash"
        pwd_len=$(echo -n "$password" | wc -c)
        pwd_stars=$(printf "%${pwd_len}s" | tr " " "*")
        echo "密码: $pwd_stars" >> "$OOBE_LOG"
        echo "$MSG_OOBE_AGREED"; echo ""

        echo "$MSG_OOBE_LICENSE"; echo "$MSG_OOBE_TERMS"; echo "$MSG_OOBE_CONTINUE"; echo ""
        while true; do echo -n "$MSG_OOBE_AGREE"; read agree; [ "$agree" = "y" ] && break; [ "$agree" = "n" ] && echo "" && echo "$MSG_OOBE_DENIED" && exit 0; echo "请输入 y 或 n"; done

        echo ""; echo "$MSG_OOBE_COMPLETE"; echo "$MSG_OOBE_ENTER"; sleep 2; echo ""
        echo "true" > "$HOME_DIR/oobe"

        echo "Microsoft Windows [版本 11.0.25276]"; echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
        echo ""; echo "本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆"; echo ""

        while true; do
            echo -n "$MSG_CMD_PROMPT"; read cmd
            [ "$cmd" = "exit" ] && echo "正在退出交互模式..." && break
            [ -z "$cmd" ] && continue
            cmd_name=$(echo "$cmd" | awk '{print $1}'); cmd_args=$(echo "$cmd" | cut -d' ' -f2-)
            case "$cmd_name" in
                mkdir) [ -z "$cmd_args" ] && echo "$MSG_CMD_MKDIR_USAGE" || { mkdir -p "$PHYSICAL_DIR/$cmd_args" && echo "$MSG_CMD_MKDIR_CREATED: $cmd_args"; } ;;
                echo|ping) eval "$cmd" ;;
                dir) ls -la "$PHYSICAL_DIR" ;;
                cd) [ -z "$cmd_args" ] && PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator" || { [ "$cmd_args" = ".." ] && PHYSICAL_DIR="$(dirname "$PHYSICAL_DIR")" || { [ -d "$PHYSICAL_DIR/$cmd_args" ] && PHYSICAL_DIR="$PHYSICAL_DIR/$cmd_args" || echo "$MSG_CMD_CD_NOTFOUND"; }; } ;;
                cls) clear ;;
                ver) echo "Microsoft Windows [版本 11.0.25276]" ;;
                type) [ -z "$cmd_args" ] && echo "$MSG_CMD_TYPE_USAGE" || cmd_type "$PHYSICAL_DIR/$cmd_args" ;;
                find) [ -z "$cmd_args" ] && echo "$MSG_CMD_FIND_USAGE" || { text=$(echo "$cmd_args" | cut -d'"' -f2); file=$(echo "$cmd_args" | awk '{print $NF}'); cmd_find "$text" "$PHYSICAL_DIR/$file"; } ;;
                tasklist) cmd_tasklist ;;
                whoami) whoami ;;
                hostname) hostname ;;
                date) date ;;
                time) date +%T ;;
                systeminfo)
                    echo "主机名:           $(hostname)"; echo "操作系统名称:     Microsoft Windows 11 Server 25H2"
                    echo "操作系统版本:     11.0.25276"; echo "制造商:           xiaofang"; echo "系统类型:         x64-based PC"
                    echo "处理器:           模拟 x64"; echo "物理内存:         $(free -m | awk '/^Mem:/{print $2}') MB"
                    echo "可用物理内存:     $(free -m | awk '/^Mem:/{print $4}') MB"
                    echo "虚拟内存:         $(free -m | awk '/^Swap:/{print $2}') MB"
                    echo "可用虚拟内存:     $(free -m | awk '/^Swap:/{print $4}') MB"
                    echo "安装时间:         $(stat -c %y "$HOME_DIR/status" 2>/dev/null | cut -d. -f1)"
                    echo "系统目录:         $HOME_DIR/C:/Windows/System32"; echo "用户目录:         $PHYSICAL_DIR"
                    ;;
                help)
                    echo "$MSG_HELP_TITLE"; echo ""; echo "$MSG_HELP_CMDS"; echo "$MSG_HELP_CD"
                    echo "$MSG_HELP_MKDIR"; echo "$MSG_HELP_CLS"; echo "$MSG_HELP_VER"
                    echo "$MSG_HELP_SYSTEMINFO"; echo "$MSG_HELP_ECHO"; echo "$MSG_HELP_PING"
                    echo "$MSG_HELP_TYPE"; echo "$MSG_HELP_FIND"; echo "$MSG_HELP_TASKLIST"
                    echo "$MSG_HELP_WHOAMI"; echo "$MSG_HELP_HOSTNAME"; echo "$MSG_HELP_DATE"
                    echo "$MSG_HELP_TIME"; echo "$MSG_HELP_EXIT"; echo ""; echo "$MSG_HELP_MORE"
                    ;;
                *) [ -f "$HOME_DIR/C:/Windows/System32/$cmd_name" ] && echo "$MSG_CMD_NODEV" || { echo "'$cmd' $MSG_CMD_NOT_FOUND"; echo "$MSG_CMD_UNKNOWN"; } ;;
            esac
        done
        ;;
    lang)
        [ "$2" = "list" ] && {
            echo "可用语言列表："
            for f in "$LANG_DIR"/*.lang; do
                [ -f "$f" ] || continue; lang_code=$(basename "$f" .lang)
                lang_name=$(grep "^LANG_NAME=" "$f" | cut -d'"' -f2)
                [ "$lang_code" = "$CURRENT_LANG" ] && current=" (当前)" || current=""
                echo "  $lang_code - $lang_name$current"
            done
        } || [ -f "$LANG_DIR/$2.lang" ] && {
            echo "$2" > "$LANG_DIR/lang.conf"
            echo "语言已切换为：$(grep "^LANG_NAME=" "$LANG_DIR/$2.lang" | cut -d'"' -f2)"
            echo "请重新执行 windows 命令以生效"
            exit 0
        } || {
            echo "错误：语言 '$2' 不存在"; echo "可用语言列表："
            for f in "$LANG_DIR"/*.lang; do [ -f "$f" ] && basename "$f" .lang; done
        }
        ;;
    "")
        check_installed; check_reboot; check_oobe; check_password
        echo "Microsoft Windows [版本 11.0.25276]"; echo "版权所有 (c) 2026 xiaofang。保留所有权利。"
        echo ""; echo "本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆"; echo ""
        while true; do
            echo -n "$MSG_CMD_PROMPT"; read cmd
            [ "$cmd" = "exit" ] && echo "正在退出交互模式..." && break
            [ -z "$cmd" ] && continue
            cmd_name=$(echo "$cmd" | awk '{print $1}'); cmd_args=$(echo "$cmd" | cut -d' ' -f2-)
            case "$cmd_name" in
                mkdir) [ -z "$cmd_args" ] && echo "$MSG_CMD_MKDIR_USAGE" || { mkdir -p "$PHYSICAL_DIR/$cmd_args" && echo "$MSG_CMD_MKDIR_CREATED: $cmd_args"; } ;;
                echo|ping) eval "$cmd" ;;
                dir) ls -la "$PHYSICAL_DIR" ;;
                cd) [ -z "$cmd_args" ] && PHYSICAL_DIR="$HOME_DIR/C:/Users/Administrator" || { [ "$cmd_args" = ".." ] && PHYSICAL_DIR="$(dirname "$PHYSICAL_DIR")" || { [ -d "$PHYSICAL_DIR/$cmd_args" ] && PHYSICAL_DIR="$PHYSICAL_DIR/$cmd_args" || echo "$MSG_CMD_CD_NOTFOUND"; }; } ;;
                cls) clear ;;
                ver) echo "Microsoft Windows [版本 11.0.25276]" ;;
                type) [ -z "$cmd_args" ] && echo "$MSG_CMD_TYPE_USAGE" || cmd_type "$PHYSICAL_DIR/$cmd_args" ;;
                find) [ -z "$cmd_args" ] && echo "$MSG_CMD_FIND_USAGE" || { text=$(echo "$cmd_args" | cut -d'"' -f2); file=$(echo "$cmd_args" | awk '{print $NF}'); cmd_find "$text" "$PHYSICAL_DIR/$file"; } ;;
                tasklist) cmd_tasklist ;;
                whoami) whoami ;;
                hostname) hostname ;;
                date) date ;;
                time) date +%T ;;
                systeminfo)
                    echo "主机名:           $(hostname)"; echo "操作系统名称:     Microsoft Windows 11 Server 25H2"
                    echo "操作系统版本:     11.0.25276"; echo "制造商:           xiaofang"; echo "系统类型:         x64-based PC"
                    echo "处理器:           模拟 x64"; echo "物理内存:         $(free -m | awk '/^Mem:/{print $2}') MB"
                    echo "可用物理内存:     $(free -m | awk '/^Mem:/{print $4}') MB"
                    echo "虚拟内存:         $(free -m | awk '/^Swap:/{print $2}') MB"
                    echo "可用虚拟内存:     $(free -m | awk '/^Swap:/{print $4}') MB"
                    echo "安装时间:         $(stat -c %y "$HOME_DIR/status" 2>/dev/null | cut -d. -f1)"
                    echo "系统目录:         $HOME_DIR/C:/Windows/System32"; echo "用户目录:         $PHYSICAL_DIR"
                    ;;
                help)
                    echo "$MSG_HELP_TITLE"; echo ""; echo "$MSG_HELP_CMDS"; echo "$MSG_HELP_CD"
                    echo "$MSG_HELP_MKDIR"; echo "$MSG_HELP_CLS"; echo "$MSG_HELP_VER"
                    echo "$MSG_HELP_SYSTEMINFO"; echo "$MSG_HELP_ECHO"; echo "$MSG_HELP_PING"
                    echo "$MSG_HELP_TYPE"; echo "$MSG_HELP_FIND"; echo "$MSG_HELP_TASKLIST"
                    echo "$MSG_HELP_WHOAMI"; echo "$MSG_HELP_HOSTNAME"; echo "$MSG_HELP_DATE"
                    echo "$MSG_HELP_TIME"; echo "$MSG_HELP_EXIT"; echo ""; echo "$MSG_HELP_MORE"
                    ;;
                *) [ -f "$HOME_DIR/C:/Windows/System32/$cmd_name" ] && echo "$MSG_CMD_NODEV" || { echo "'$cmd' $MSG_CMD_NOT_FOUND"; echo "$MSG_CMD_UNKNOWN"; } ;;
            esac
        done
        ;;
    *) echo "用法: windows {install|stop|version|uninstall|shutdown|oobe|lang}"
        echo "  install      安装系统"; echo "  stop         暂停操作"; echo "  version      显示版本"
        echo "  uninstall    卸载系统"; echo "  shutdown /r  重启系统"; echo "  oobe         OOBE 设置向导"
        echo "  lang list    列出所有语言"; echo "  lang <code>  切换语言 (zh-CN, zh-TW, en-US, ja-JP)"
        echo "直接输入 windows 进入交互模式" ;;
esac
