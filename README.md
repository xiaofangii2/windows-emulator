# Windows 11 Server 模拟器

一个在 Termux / Linux 终端里模拟 Windows 11 Server 命令行环境的 Shell 脚本。

## 功能

- 模拟 Windows 11 Server 安装过程（带进度条）
- OOBE 设置向导（地区、键盘布局、用户名、激活码、密码）
- 交互式 CMD 命令行模拟
- 支持从 GitHub 自动下载命令包（command.zip）
- 支持 dir、ping、ipconfig、systeminfo 等常用 Windows 命令
- 激活码验证系统（可选）
- 密码登录（SHA256 哈希存储）
- 卸载时完全清理

## 使用

### 基本命令

- windows install —— 安装系统
- windows shutdown /r —— 重启系统
- windows oobe —— OOBE 设置向导
- windows version —— 查看版本
- windows uninstall —— 卸载系统
- windows —— 进入交互式 CMD

### 交互模式命令

- dir —— 显示当前目录内容
- cd —— 切换目录（cd .. 返回上级）
- mkdir —— 创建目录
- cls —— 清屏
- ver —— 显示版本信息
- systeminfo —— 显示系统信息
- echo —— 显示信息
- ping —— 测试网络连通性
- type —— 显示文件内容
- find —— 在文件中搜索文本
- tasklist —— 显示进程列表
- whoami —— 显示当前用户
- hostname —— 显示主机名
- date —— 显示当前日期
- time —— 显示当前时间
- help —— 显示帮助信息
- exit —— 退出交互模式

## 命令包

安装过程中会自动从 GitHub Releases 下载 command.zip，解压到 C:\Windows\System32\。下载失败不影响安装，但部分命令可能不可用。

## 激活码

OOBE 过程中可留空跳过。激活码通过外网 API 验证（http://css.xiaofangii.dpdns.org:8080/verify）。

## 兼容性

- Android (Termux) —— 完全支持
- Linux —— 支持（需要 bash、openssl、curl、unzip）
- macOS —— 理论兼容，未测试
- Windows (WSL) —— 支持（通过 WSL 运行）

## 依赖

- bash
- openssl
- curl
- unzip

## 免责声明

本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆。仅供个人学习、研究使用，禁止任何形式的商业用途。

## 许可证

保留所有权利，禁止商用。

## 安装

点击[这个链接](https://github.com/xiaofangii2/windows-emulator/releases)
下载最新版的模拟器安装脚本即可
