# Windows 11 Server 25H2 模拟器

一个在 Termux / Linux 终端里模拟 Windows 11 Server 命令行环境的 Shell 脚本。

## 功能

- 模拟 Windows 11 Server 安装过程（带进度条）
- 支持暂停安装（Ctrl+C 或输入 stop）
- 交互式 CMD 命令行模拟
- 支持 mkdir、echo、ping 等基础命令
- 未开发命令提示暂时未开发，请下个版本再试
- 不支持的命令提示不是内部或外部命令

## 安装

```bash
git clone https://github.com/xiaofangii2/windows-emulator.git
cd windows-emulator
chmod +x windows.sh
./windows.sh install
```

## 使用

```bash
windows install        # 安装
windows shutdown /r    # 重启
windows version        # 查看版本
windows uninstall      # 卸载
windows                # 进入交互式 CMD
```

## 免责声明

本项目不隶属于 Microsoft，不应与 Microsoft 产品混淆。仅供学习研究使用，禁止商业用途。

## 许可证

保留所有权利，禁止商用。
