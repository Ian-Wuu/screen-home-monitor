# 从源码开始

中文 · [English](#english)

需要 Apple Silicon Mac（macOS 13+、Command Line Tools、FFmpeg），以及同局域网的 Linux 主机（Python 3、Docker Engine、Compose 插件）。

## Linux

取得仓库并进入根目录，将示例主机名替换成 Linux 主机真实 LAN 地址：

```sh
python3 scripts/setup-server.py --host screen-server.local
cd server
sudo docker compose up -d
```

随机账号地址保存在 `server/private/connection.txt`，不要公开或上传。此部署面向新服务器；已有 MediaMTX/Scrypted 时先检查端口冲突与数据目录。

## Mac

在 Mac 的仓库根目录执行，假设已安装 Homebrew：

```sh
xcode-select --install
brew install ffmpeg
zsh macOS/scripts/self-check.sh
zsh macOS/scripts/build.sh
```

已安装 Command Line Tools 时跳过第一条。把构建结果 `dist/AI Screen Stream.app` 放进固定 Applications 目录打开。进入 Settings，填写 Linux 生成的 Mac publish URL；选屏后 Start Streaming 并授予系统录屏权限。

## Apple 家庭

在自己服务器的 `https://<服务器地址>:10443` 完成 Scrypted 初始设置。安装 RTSP Camera 和 HomeKit 插件，使用 Camera read URL 创建摄像头，确认预览后扫码配对。

继续阅读[接入与日常使用](SETUP.md)、[故障处理](TROUBLESHOOTING.md)和[验证范围](VERIFICATION.md)。

---

## English

### Build from source

Requirements: Apple Silicon Mac (macOS 13+, Command Line Tools, FFmpeg) and a Linux host on the same LAN (Python 3, Docker Engine, Compose plugin).

### Linux

From the repository root, replace the example hostname with the Linux host's actual LAN address:

```sh
python3 scripts/setup-server.py --host screen-server.local
cd server
sudo docker compose up -d
```

Generated credentials and URLs are in `server/private/connection.txt`. Keep them private. This setup targets new deployments; check port conflicts and data directories before using it alongside an existing MediaMTX/Scrypted installation.

### Mac

From the repository root, assuming Homebrew is installed:

```sh
xcode-select --install
brew install ffmpeg
zsh macOS/scripts/self-check.sh
zsh macOS/scripts/build.sh
```

Skip the first command if Command Line Tools are installed. Move `dist/AI Screen Stream.app` into a consistent Applications directory. Open Settings and enter the generated Mac publish URL. Select a display, click Start Streaming and grant Screen Recording permission.

### Apple Home

Complete Scrypted onboarding at `https://<server-address>:10443` on your server. Install RTSP Camera and HomeKit, create a camera using the Camera read URL, verify the preview and scan its pairing code in Home.

Continue with [Home setup and daily use](SETUP.md), [troubleshooting](TROUBLESHOOTING.md) and [verification boundaries](VERIFICATION.md).
