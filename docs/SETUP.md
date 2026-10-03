# Setup and daily use / 安装后配置与日常使用

[English](#english) · [中文](#中文)

## English

### Scrypted → Apple Home

1. Start the services as described in the README. Open `https://<server-address>:10443` on your own server and create a Scrypted account. The initial certificate may be self-signed.
2. Install `RTSP Camera` (`@scrypted/rtsp`) and `HomeKit` (`@scrypted/homekit`) from Plugins. Create a camera, for example `Mac Screen`.
3. Enter the Camera read URL from `server/private/connection.txt`. Select TCP if the plugin exposes a transport option. Start streaming on the Mac and confirm continuous playback in Scrypted first.
4. Enable HomeKit for this camera using **Accessory Mode**. Select the server's real, reachable LAN address in Scrypted settings. With multiple network interfaces, check HomeKit's mDNS Interfaces setting.
5. Open this camera's HomeKit → Pairing section and scan its QR code using Add Accessory in the iPhone Home app. Each camera has its own code; do not confuse it with the Scrypted bridge code.
6. Check Mac, iPhone over Wi-Fi and Apple TV, then disable iPhone Wi-Fi to test cellular access. Watch changing content for at least 30 seconds each time. Updating thumbnails alone do not establish live playback.

If Scrypted plays the source but a Home client fails, follow the troubleshooting guide. The original personal deployment used **RTP Sender = FFmpeg** and **Transcode Video** in the camera's HomeKit settings for compatibility. Transcoding uses server CPU; enable it when there is a demonstrated need. This repository does not automatically edit Scrypted's internal database.

See the [official HomeKit guide](https://docs.scrypted.app/homekit.html). Field names may change across plugin versions. A pinned Docker image does not pin plugins installed later; record their installed versions separately.

### Optional Home Assistant camera

In an existing HA installation, use Settings → Devices & services → Add integration → Generic Camera. Enter the same read URL with TCP. Suggested name: `AI Workspace`; entity ID: `camera.ai_workspace`, if available. If authentication has separate fields, enter the read username and password there.

This repository does not rewrite HA's `configuration.yaml` or create an additional HA HomeKit camera. When migrating from an old HA HomeKit camera, confirm the new Scrypted accessory works before removing the old accessory and disabling its export. Do not disable an entire bridge that also carries other home devices.

See the [official Generic Camera guide](https://www.home-assistant.io/integrations/generic/).

### Daily use

- Choose Display → Start Streaming in the Mac menu bar. Stop Streaming or Quit stops capture.
- Display switching keeps the same camera address and Home pairing.
- Launch at login opens the app; sharing still starts manually.
- Mac sleep, stopping the app, disconnecting the selected display or losing server connectivity can make the camera unavailable.
- `Streaming` means the sender process is running. It does not verify decoding on each Apple client; check with moving content.

### Remote viewing

Use Apple Home through an online home hub. Do not forward RTSP port 8554 or the Scrypted management port to the Internet. The hub, Mac sender and Linux services must remain online.

The original deployment was tested remotely with Apple TV as the active hub. HomePod failover was not equivalently verified. Turning off a television panel differs from disconnecting Apple TV power: keep Apple TV powered and connected, and check hub status in Home.

This project provides live viewing only. It does not configure HomeKit Secure Video recording, motion detection or an iCloud recording subscription.

---

## 中文

### Scrypted → Apple 家庭

1. 按 README 启动服务。在自己的服务器打开 `https://<服务器地址>:10443`，创建 Scrypted 账号。初始证书可能是自签名证书。
2. 在 Plugins 中安装 `RTSP Camera`（`@scrypted/rtsp`）和 `HomeKit`（`@scrypted/homekit`）。创建摄像头并命名，例如 `Mac Screen`。
3. 填入 `server/private/connection.txt` 中的 Camera read URL。传输方式选择 TCP（若当前插件界面提供该选项）。先在 Mac App 开始推流，确认 Scrypted 预览连续更新。
4. 为这台摄像头启用 HomeKit，以 **Accessory Mode** 独立配件方式导出。在 Scrypted 服务器设置中选择可被家庭设备访问的真实 LAN 地址；多网卡时检查 HomeKit 的 mDNS Interfaces。
5. 在这台摄像头的 HomeKit → Pairing 打开二维码，用 iPhone 家庭 → 添加配件配对。每台摄像头有自己的二维码，不要把 Scrypted 桥接二维码当成摄像头二维码。
6. 依次验证 Mac、iPhone Wi-Fi、Apple TV，最后关闭 iPhone Wi-Fi 测试蜂窝网络。每次看动态内容至少 30 秒，缩略图更新不代表实时流正常。

如果源流可以播放但某类 Home 客户端失败，参考故障文档。原个人部署曾使用 HomeKit 摄像头设置里的 **RTP Sender = FFmpeg**、**Transcode Video** 来兼容客户端。这会占用服务器 CPU，应在有实际兼容问题时使用；公开项目不自动修改 Scrypted 的内部数据库。

Scrypted 配对方式参照[官方 HomeKit 文档](https://docs.scrypted.app/homekit.html)。插件界面的字段可能随版本变化；Docker 镜像固定不意味着首次安装的插件版本固定。请记录本机插件版本。

### 可选：在 Home Assistant 中显示

HA 已安装的情况下，从 设置 → 设备与服务 → 添加集成 → Generic Camera 接入同一个 RTSP 读流地址，使用 TCP。可把名称设为 `AI Workspace`、实体 ID 设为 `camera.ai_workspace`（没有重名时）。若表单分开要求认证信息，把读流账号与密码填入对应字段。

本项目不改写 HA 的 `configuration.yaml`，也不另行创建 HA HomeKit 摄像头。旧 HA HomeKit 摄像头若已配对，先确认新 Scrypted 摄像头可用，再移除旧配件并禁用其 HA 导出配置。不要禁用包含其他家居设备的整个桥。

HA 摄像头接入参数参照[官方 Generic Camera 文档](https://www.home-assistant.io/integrations/generic/)。

### 日常操作

- Mac 菜单栏选择 Display → Start Streaming。停止共享用 Stop Streaming，退出 App 也会停止采集。
- 切换显示器后使用同一个摄像头地址；不需要重新配对家庭。
- Launch at login 只启动菜单栏 App，需要自己开始共享。
- Mac 休眠、App 停止、所选显示器拔出或服务器断网时，摄像头可能无响应。
- `Streaming` 表示发送进程仍在运行，当前实现不验证每台 Apple 客户端成功解码。使用动态画面确认实际播放。

### 远程观看

通过 Apple 家庭的家庭中枢访问，不把 RTSP 8554 或 Scrypted 管理端口映射到公网。需要家庭中枢、Mac 推流和 Linux 服务都在线。

原部署通过 Apple TV 作为当前家庭中枢验证过远程画面。HomePod 故障切换没有完成同等验证。电视面板关机与 Apple TV 断电不同：保持 Apple TV 的电源和网络连接；实际中枢在线状态以家庭 App 为准。

这里仅提供实时画面；不配置 HomeKit Secure Video 录像、运动检测或 iCloud 录像订阅。
