# Screen Home Monitor

[English](#english) · [中文](#中文)

<img src="docs/assets/logo.png" width="100" alt="Screen Home Monitor double-screen logo">

[License](LICENSE) · [Get started](docs/INSTALL.md)

## English

**Your Mac screen, in Apple Home.**

Leave a render, export, build or AI task running on your Mac. Check the screen from your sofa, another room or your phone without walking back to the desk. You can also keep a status board or presentation visible through an Apple Home camera.

Screen Home Monitor is a native macOS menu-bar utility. It sends a selected display through a Linux server on your local network and exposes it as a camera in Apple Home, viewable from Apple TV, iPhone, and Mac.

The existing app bundle and identifiers retain the earlier name, AI Screen Stream, for compatibility. This repository rename does not replace your installed app or change its screen-recording identity.

It shares pixels: **there is no automatic task-state detection, completion notification, or remote control.** You read the progress from the screen yourself. No integration with an AI tool's API is required.

### Around the home

The two device images below are **hand-composited demos, not AI-generated scenes**. They use native text renders of this repository's public source and recorded self-check output, placed in manually drawn device frames. Home-style controls are simplified, not actual tvOS/iPhone screenshots or proof of live playback. The app's own interface previews are shown separately below.

<img src="docs/assets/demo-tv.png" width="800" alt="Hand-composited TV demo using public project source and test output, not a live tvOS screenshot">

**From the sofa:** open the workspace camera on Apple TV to check a long-running task, then return to what you were watching.

| Use case | What to put on the Mac screen |
| --- | --- |
| Coding and AI tasks | A terminal, build log or coding assistant waiting for input. |
| Rendering and exports | A 3D render, video export, photo batch or file-transfer progress window. |
| Personal status boards | A browser page with job queues, schedules or your own project dashboard. |
| Slides and visual references | A deck, storyboard or reference board you want to glance at elsewhere. Advance or edit it on the Mac. |
| Away from the desk | Check the same screen on your phone. Outside the LAN, Apple Home remote access needs a configured, online home hub and a working network path. |

<img src="docs/assets/demo-phone.png" width="500" alt="Hand-composited phone demo with the same sample screen in a simplified Home-style camera card">

**On your phone:** check the same workspace from another room. For exports or renders, progress comes from the app already running on the Mac, not from automatic recognition.

**A shared reference:** put your own status board on the selected display and view it from another device. The board is not a built-in feature of Screen Home Monitor.

This is a view-only convenience, not a low-latency display replacement, remote desktop, audio stream or safety-critical monitor. Keep sensitive windows and notifications off the shared display.

### Everyday workflow

1. Put a task, progress window, dashboard or visual reference on the display you want to share.
2. Select that display in the menu bar and click **Start Streaming**.
3. Open the matching Home camera on Apple TV, iPhone or Mac whenever you want to look.
4. Return to the source Mac if interaction is needed. Click **Stop Streaming** when done.

Automatic pop-ups, status overlays, and persistent picture-in-picture are not promised. Camera access on the TV depends on the Apple TV system interface.

### Interface

The menu contains display selection and stream controls. Settings contain the RTSP destination, bitrate, and launch-at-login option.

<img src="docs/assets/menu.png" width="320" alt="Native menu preview with display selection and Start Streaming">

<img src="docs/assets/settings.png" width="492" alt="Native settings preview with a hidden destination, bitrate and launch-at-login option">

These images are local renders of the actual SwiftUI components with example settings, not live-stream captures or photographs of Apple TV. Launch at login opens the app; it does not automatically start sharing.

### How it works

`Mac display → MediaMTX → Scrypted → Apple Home / Apple TV`

The Mac captures and encodes the display. MediaMTX on Linux receives and forwards the stream; Scrypted exposes it as an independent HomeKit camera accessory. Some clients may need compatibility transcoding in Scrypted, which increases Linux CPU usage.

Defaults: **1920×1080, 15 fps, H.264 VideoToolbox hardware encoding, approximately 3 Mbps, no audio, RTSP over TCP**. The app supports display switching, connection retries, and optional launch at login. There is no OCR, AI detection, recording, cloud-upload feature, or remote control. Sharing a display also exposes notifications and private windows on it.

### Project status

This repository was prepared from a personal deployment. In August 2026, the user reported working playback on Mac, Apple TV, iPhone, and remotely. One iPhone problem was resolved by disabling its proxy. This does not establish two-hour stability or compatibility across routers and operating systems.

The Mac sources are retained, while the Linux setup is repackaged as portable Compose configuration. **The new Compose setup has not been tested end to end on a fresh server.** See [verification boundaries](docs/VERIFICATION.md). Do not overwrite an existing MediaMTX/Scrypted deployment without checking its configuration and data.

### Quick start

Requirements: an Apple Silicon Mac with macOS 13+, Xcode Command Line Tools and FFmpeg; a Linux host on the same LAN with Python 3, Docker Engine and the Compose plugin. A Surface is optional. The server uses Linux host networking. An Intel Mac build target is not currently provided.

On Linux, run from the repository root and replace the example hostname with the server's actual LAN address:

```sh
python3 scripts/setup-server.py --host screen-server.local
cd server
sudo docker compose up -d
```

Random publish/read credentials and URLs are saved in `server/private/connection.txt`. Re-running setup preserves credentials. Never upload this file.

On the Mac, with Homebrew installed, run from the repository root:

```sh
xcode-select --install  # Skip if Command Line Tools are already installed.
brew install ffmpeg
zsh macOS/scripts/self-check.sh
zsh macOS/scripts/build.sh
```

Move `dist/AI Screen Stream.app` into a consistent Applications location and open it. In **Settings… → RTSP destination**, enter the generated Mac publish URL, select a display and start streaming. Grant Screen Recording access when prompted. Public builds do not embed private destination credentials and use a locally installed FFmpeg; this source package does not bundle its binary.

Visit `https://<server-address>:10443` on your own server to complete Scrypted onboarding. Install the RTSP Camera and HomeKit plugins, create a camera using the generated read URL, confirm the preview and pair it with Apple Home in Accessory Mode. Account setup, macOS permission and Home pairing require your participation. This project does not operate your Apple ID or migrate another home's pairing database.

Full instructions: [installation](docs/INSTALL.md) · [Home setup and daily use](docs/SETUP.md).

### Home Assistant is optional

**Scrypted runs independently of Home Assistant.** HA can read the same RTSP stream as an additional viewer; it is not required by the Apple Home video path. HACS is an HA community integration entry point, unrelated to this streaming path.

An earlier deployment exported the camera through HA HomeKit. This repository follows the final Scrypted setup. Avoid exporting the same screen twice, which creates confusing duplicate accessories in Home.

### Documentation

- [Home setup, daily use and remote viewing](docs/SETUP.md)
- [Maintenance, updates and GitHub upload](docs/OPERATIONS.md)
- [Frozen frames, VPN issues and permission troubleshooting](docs/TROUBLESHOOTING.md)
- [Verification boundaries](docs/VERIFICATION.md)
- [Security and privacy](SECURITY.md) · [Image provenance](docs/ASSETS.md)

### License: commercial works allowed, software commercialization restricted

This project uses the custom [Screen Home Monitor Source-Available License 1.0](LICENSE), not a standard open-source license.

- **Allowed:** personal, educational and internal business use; using the tool to create or view commercial works and complete paid projects. Independent works may be sold without a source-disclosure or royalty obligation to this project.
- **Not allowed without separate permission:** selling the source, original app, compiled or modified versions; incorporating them into commercial products; or providing them as paid, subscription-based, advertising-supported or other commercial services.
- **Non-commercial sharing:** original and modified versions may be shared with the license and copyright notices retained and modifications identified. Independent works must not incorporate or derive from this project's code or assets.

The software is provided as is, without warranty. Initial commit `7b947b4` was published under MIT. This license does not revoke earlier MIT permissions; changing the notice cannot restrict previously released code retroactively.

FFmpeg, MediaMTX, Scrypted and optional Home Assistant components retain their respective upstream licenses. Their binaries are not included in this source archive. See [third-party notices](THIRD_PARTY_NOTICES.md).

This is an independent personal project, not affiliated with, sponsored by, or certified by Apple. Apple Home, HomeKit, macOS and other product names belong to their respective owners. A [Chinese reference translation](LICENSE.zh-CN.md) accompanies the authoritative English [license](LICENSE).

---

## 中文

**把 Mac 屏幕，接入 Apple 家庭。**

让 Mac 继续渲染、导出、编译或运行 AI 任务，自己去看电视、到另一个房间，想知道进度时打开家庭摄像头看一眼，不必总往电脑前跑。也可以把状态看板、演示文稿或参考图留在屏幕上，方便从其他设备查看。

Screen Home Monitor 是一个原生 macOS 菜单栏工具：把选中的屏幕作为视频源，通过局域网里的 Linux 主机接入 Apple「家庭」。Apple TV、iPhone 和 Mac 都可以查看。

为保持兼容，现有 App 文件名与标识保留旧名称 AI Screen Stream。本次仓库更名不会替换已安装的 App 或改变其录屏授权身份。

它共享的是屏幕画面，**不自动识别 AI 状态、不发送完成通知，也不能远程点击电脑**。任务进行到了哪里，由你看画面判断；不需要接入 AI 工具的 API。

### 使用场景

以下两张设备图是**手工合成演示，不是 AI 生成场景**：将本项目公开源码与已记录的自检结果进行原生文字渲染，再放入手绘设备边框。家庭风格控件经过简化，不是 tvOS／iPhone 真实截图，也不作为实时播放证据。App 自身的界面预览在后面单独展示。

<img src="docs/assets/demo-tv.png" width="800" alt="手工合成的电视演示图，使用公开项目源码和自检结果，不是 tvOS 实拍">

**坐在沙发上：** 在 Apple TV 打开工作屏幕摄像头，看一眼长任务的进展，再回到正在看的节目。

| 场景 | Mac 屏幕上放什么 |
| --- | --- |
| 编程与 AI 任务 | 终端、编译日志，或可能需要你接手的编程助手。 |
| 渲染与导出 | 3D 渲染、视频导出、批量修图或文件传输的进度窗口。 |
| 个人状态看板 | 展示任务队列、日程或项目看板的浏览器页面。 |
| 演示与参考资料 | 幻灯片、分镜或参考图板；翻页和编辑仍在 Mac 上操作。 |
| 离开电脑后查看 | 在手机上看同一块屏幕；局域网外访问需要已配置且在线的 Apple 家庭中枢和正常网络链路。 |

<img src="docs/assets/demo-phone.png" width="500" alt="手工合成的手机演示图，简化的家庭风格卡片内显示同一份示例画面">

**拿起手机看一眼：** 在另一个房间查看同一块工作屏幕。若查看导出或渲染，进度来自 Mac 上原本运行的软件，不是本工具自动识别的结果。

**随处查看参考信息：** 将自己的看板放在选中的显示器上，从另一台设备查看。看板不是 Screen Home Monitor 的内置功能。

这是只读查看工具，不是低延迟外接显示器、远程桌面、音频传输或安全关键监控。共享前请移开敏感窗口，并注意通知内容。

### 日常操作

1. 把任务、进度窗口、看板或参考资料放在准备共享的显示器上。
2. 在菜单栏选择这块显示器，点击 **Start Streaming**。
3. 需要查看时，在 Apple TV、iPhone 或 Mac 上打开对应的家庭摄像头。
4. 需要操作时回到源 Mac；用完后点 **Stop Streaming**。

这里不承诺自动弹窗、状态叠加或持续画中画；电视端如何打开摄像头取决于 Apple TV 的系统界面。

### 界面

菜单栏：选择屏幕，开始或停止共享。

<img src="docs/assets/menu.png" width="320" alt="菜单栏界面：显示器选择与 Start Streaming 按钮">

设置：推流地址、码率与登录启动。

<img src="docs/assets/settings.png" width="492" alt="设置界面：隐藏的推流地址、3 Mbps 码率和登录启动开关">

以上图片由真实 SwiftUI 组件在本机渲染，使用示例配置；不是实时投屏或 Apple TV 实拍。

### 工作方式

`Mac 屏幕 → MediaMTX → Scrypted → Apple 家庭 / Apple TV`

Mac 负责采集和编码，Linux 上的 MediaMTX 接收并转发，Scrypted 将它作为独立 HomeKit 摄像头接入家庭。某些客户端需要启用 Scrypted 兼容性转码，会增加 Linux 主机 CPU 占用。

Mac 端默认输出 **1920×1080、15 fps、H.264、约 3 Mbps、无音频**。菜单栏选屏，手动开始和停止；支持切屏、断线重试和登录启动。登录启动不会自动投屏。

查看 AI 任务只是使用场景，不包含 AI 识别功能。没有 OCR、录像、云端上传或远程控制功能。家庭成员能看到整块被选中的屏幕，包括通知和私人窗口。

### 项目状态

这是从个人实际部署整理出的源码项目。2026 年 8 月的使用反馈确认过 Mac、Apple TV、iPhone 和远程观看可用；iPhone 的一次故障通过关闭手机代理恢复。这里没有发布两小时稳定性、跨路由器兼容性或自动迁移的保证。

发布目录保留现有 Mac 源码，重新提供便携的 Linux Compose 配置。**新的 Compose 部署尚未在全新服务器上端到端验证**；源码构建与配置生成检查见 [验证记录](docs/VERIFICATION.md)。不要直接覆盖已有的 MediaMTX/Scrypted 部署。

### 快速开始

需要 Apple Silicon Mac（macOS 13+、Xcode Command Line Tools、FFmpeg），以及同局域网的 Linux 主机（Python 3、Docker Engine 和 Compose 插件）。Surface 不是必需；服务器采用 Linux host networking。Intel Mac 暂未提供构建目标。

**1. 在 Linux 上准备服务**

下载/克隆本仓库并进入仓库根目录，把下面主机名换成 Linux 主机真实的局域网 IP 或可解析名称：

```sh
python3 scripts/setup-server.py --host screen-server.local
cd server
sudo docker compose up -d
```

随机凭据及推流、读流地址写在 `server/private/connection.txt`。重复生成保留原凭据。文件不会自动提交到 Git。

**2. 在 Mac 上构建**

在 Mac 的仓库根目录执行；以下假设已安装 Homebrew：

```sh
xcode-select --install  # 已安装 Command Line Tools 可跳过
brew install ffmpeg
zsh macOS/scripts/self-check.sh
zsh macOS/scripts/build.sh
```

把 `dist/AI Screen Stream.app` 放进固定的 Applications 目录后打开。在菜单栏 **Settings… → RTSP destination** 填入上一步的 Mac publish URL，然后选屏、点 **Start Streaming**，按系统提示授予屏幕录制权限。

发布构建不会嵌入你的 RTSP 凭据。默认依赖本机 Homebrew FFmpeg；这份源码包不附带 FFmpeg 二进制。

**3. 接入家庭**

打开 `https://screen-server.local:10443`，确认访问的是自己的 Linux 主机后，完成 Scrypted 的初始账号设置。安装 RTSP Camera 与 HomeKit 插件，创建 RTSP 摄像头，填入 Camera read URL，确认预览，再以独立配件配对 Apple 家庭。完整步骤见 [接入与使用](docs/SETUP.md)。

首次账号设置、macOS 系统录屏授权、Apple 家庭配对需要本人完成。项目不自动操作 Apple ID，也不迁移其他家庭的配对数据库。

### Home Assistant 与 Scrypted 的关系

**Scrypted 独立于 Home Assistant 运行。** Apple 家庭的视频路径不依赖 HA；HA 只是可选的另一位 RTSP 观看者。HACS 是 HA 的社区集成入口，与这条推流链路无关。

旧版本曾通过 HA HomeKit 导出摄像头；这份项目采用最终使用的 Scrypted 路径。迁移时不要再同时导出同一块屏幕，否则家庭中会出现两个容易混淆的配件。

### 文档

- [接入、日常操作与远程观看](docs/SETUP.md)
- [维护、版本、更新和 GitHub 上传](docs/OPERATIONS.md)
- [转圈、静帧、VPN 与权限排查](docs/TROUBLESHOOTING.md)
- [验证范围](docs/VERIFICATION.md)
- [安全与第三方组件](SECURITY.md)、[第三方说明](THIRD_PARTY_NOTICES.md)

### 使用许可：允许商业作品，禁止软件商业化

本项目使用自定义的 [Screen Home Monitor Source-Available License 1.0](LICENSE)，不是标准开源许可。

- **允许**：个人、学习、企业内部使用；用本工具制作或查看商业作品、完成付费项目。独立作品可以出售，无需因此开源或向本项目支付费用。
- **禁止**：未经另行授权，将本软件源码、原版、编译版或修改版售卖，包装进商业产品，或作为付费、订阅、广告变现等商业服务提供。
- **非商业分享**：可以分享原版或修改版，须保留许可和版权声明，并注明修改。独立作品不包含或衍生自本软件代码、素材。

软件按现状提供，不附带担保。初始提交 `7b947b4` 曾按 MIT 发布；新许可不撤回此前已授予的 MIT 权利，不能靠换声明限制已发布的早期代码。

FFmpeg、MediaMTX、Scrypted 和可选的 Home Assistant 各自遵循其上游许可；源码包不包含这些组件的二进制。详见 [第三方组件说明](THIRD_PARTY_NOTICES.md)。

本项目为个人独立项目，与 Apple 无隶属或赞助关系，未获 Apple 官方认证。Apple Home、HomeKit、macOS 等名称归各自权利人所有。

完整条款见[中文参考译文](LICENSE.zh-CN.md)，以英文 [LICENSE](LICENSE) 为准。
