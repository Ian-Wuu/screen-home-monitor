# Troubleshooting / 故障处理

[English](#english) · [中文](#中文)

## English

### iPhone keeps loading while Mac or Apple TV works

During troubleshooting in the original installation, the iPhone requested HomeKit video delivery to `198.18.0.1`. Disabling its proxy restored playback. This implicated that proxy network path in that incident; the address alone does not establish the same root cause on every device. A log entry such as `packet loss 22` must not be interpreted directly as 22 loss events or a percentage.

Temporarily disable the iPhone VPN/proxy and reopen Home as a comparison test. If playback returns, follow the proxy app's instructions to bypass local traffic. Website-domain bypass rules alone may not change the network interface selected by HomeKit. Do not copy someone else's virtual-address routes or NAT rules.

The original Apple TV setup also used device-specific routing. Those rules depend on its gateway and client network and are intentionally excluded from this generic deployment.

### Old thumbnails, frozen frames or infrequent updates

Home overview snapshots and opened live video are separate requests. Check Scrypted's live preview first, then Home playback. Working upstream RTSP/TCP does not prove that HomeKit's bidirectional UDP/SRTP path works.

The Mac app captures with ScreenCaptureKit and repeats the latest frame at 15 fps, feeding the encoder even when the desktop is static. Test with a moving clock or scrolling page rather than judging frame rate from a still desktop.

If all clients fail, inspect Mac status, screen-recording permission, service logs and the source stream. If only one fails, inspect its proxy, guest Wi-Fi/AP isolation, firewall, mDNS and return UDP path. RTCP timeouts call for address and bidirectional-network checks first.

### Scrypted plays, but Home clients cannot decode

Confirm H.264 rather than HEVC. The Mac currently uses baseline, level 4.0, no B-frames and an approximately one-second GOP. Then consider FFmpeg RTP Sender / Transcode Video in the camera's advanced HomeKit settings; names vary by plugin version. Monitor CPU load and client playback.

MediaMTX only forwards video. Enabling Scrypted transcoding does encode on the Linux host, so that configuration is not a no-transcoding server. Slow Mode Addresses primarily changes source selection; with a single source, it does not guarantee lower output resolution or bitrate.

### Screen-recording permission resets after updates

Keep the installation path, Bundle ID and signing identity stable. The build script supports `AI_SIGN_IDENTITY`; without a stable signing identity, ad-hoc builds may require permission again after updates. Setting an environment variable does not create a certificate or notarize an app.

In System Settings, confirm that screen-recording access is granted to the current app in Applications, then quit and reopen it. Do not repeatedly change the Bundle ID to work around permissions.

### Services fail to start or connect

From `server/` on Linux:

```sh
sudo docker compose ps
sudo docker compose logs --tail 100 mediamtx
sudo docker compose logs --tail 100 scrypted
```

Check for conflicts on ports 8554, 10443 and dynamic HomeKit ports. This Compose configuration uses Linux host networking. Do not stop every existing home service just to test it.

Redact diagnostics before sharing. Complete FFmpeg command lines and logs may contain RTSP passwords, SRTP session keys or pairing information.

See [Scrypted's HomeKit documentation](https://docs.scrypted.app/homekit.html) for additional network troubleshooting.

---

## 中文

### iPhone 一直转圈，但 Mac 或 Apple TV 正常

本项目的实际排查中，iPhone 曾向 HomeKit 请求将视频发往 `198.18.0.1`，关闭手机代理后恢复。该结果说明当时的代理网络路径参与了故障，但不能仅凭这个地址确定所有设备上的同一种根因。日志的 `packet loss 22` 也不能直接当作“22 次丢包事件”或百分比。

先在 iPhone 暂时停用 VPN/代理并重新打开家庭，以此做对照。若恢复，再按代理 App 的说明配置本地网络绕过；仅设置网站域名直连未必会改变 HomeKit 选择的网络接口。不要照搬别人的虚拟地址静态路由或 NAT 规则。

原现场针对 Apple TV 还使用过专用路由，但其网关地址、客户端网络与设备一一对应；这些规则没有放入通用部署。

### 只看到旧缩略图、静止一帧或画面几秒更新一次

家庭主页快照与点开后的实时视频是不同请求。先检查 Scrypted 实时预览，再检查家庭播放。上游 RTSP/TCP 正常不保证 HomeKit 的 UDP/SRTP 双向路径正常。

本 Mac 程序通过 ScreenCaptureKit 采集，并按 15 fps 定时重复最新帧，即使桌面没有变化也持续给编码器供帧。客户端卡顿时，不要仅凭静止桌面判断帧率；播放时钟或滚动页面比较。

若所有客户端都坏：检查 Mac 状态、录屏权限、服务日志与源流。如果仅一个客户端坏：先排查该客户端代理、访客 Wi-Fi/AP 隔离、防火墙、mDNS 和回程 UDP。若日志等待 RTCP 超时，优先排查地址与双向网络。

### Scrypted 可播，家庭客户端无法解码

确认源是 H.264，而不是 HEVC。Mac 当前使用 baseline、level 4.0、无 B 帧、约一秒 GOP。再考虑在摄像头 HomeKit 高级设置启用 FFmpeg RTP Sender / Transcode Video（名称依插件版本而异），观察 CPU 和客户端结果。

MediaMTX 只转发；启用 Scrypted 转码后，Linux 主机确实会编码，不能称为“服务器完全不转码”。“Slow Mode Addresses”主要改变源流选择；只有一路源时，不保证最终输出尺寸或码率真的下降。

### 更新后又要求录屏权限

保持安装路径、Bundle ID 和签名身份一致。构建脚本支持 `AI_SIGN_IDENTITY`，没有稳定签名身份时使用 ad-hoc 签名；这类本机构建更新可能再次触发授权。设置环境变量并不会创建证书，也不等于 Apple 公证。

在系统设置的屏幕录制权限里确认当前 Applications 路径的 App，关闭并重新打开 App。不要靠不停改变 Bundle ID 绕过权限问题。

### 服务启动或连接失败

在 Linux 的 `server/` 下执行：

```sh
sudo docker compose ps
sudo docker compose logs --tail 100 mediamtx
sudo docker compose logs --tail 100 scrypted
```

检查 8554、10443 及 HomeKit 动态端口是否与旧服务冲突。该 Compose 使用 host networking，适用于 Linux。不要为了测试把已有的家庭服务整套关闭。

查看日志时不要公开完整 FFmpeg 命令行：里面可能含 RTSP 密码、SRTP 会话密钥和配对信息。分享前遮盖这些内容。

更完整的网络建议见 [Scrypted HomeKit 故障文档](https://docs.scrypted.app/homekit.html)。
