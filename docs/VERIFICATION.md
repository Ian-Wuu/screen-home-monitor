# Verification boundaries / 验证范围

[English](#english) · [中文](#中文)

## English

Repository preparation date: 2026-10-03. This is not a claim that the home devices were retested on that date.

### Local checks

- Configuration self-checks passed: random credential generation, credential reuse, restrictive file permissions, invalid-host rejection and corrupted-credential rejection.
- Compose, MediaMTX template and GitHub Actions YAML parsing passed, as did release/build script syntax checks.
- Git ignore rules cover server secrets, Scrypted data, FFmpeg binaries, build outputs and local environment files.
- Mac self-checks and compilation for Apple Silicon with a macOS 13 target passed. Public builds use a credential-free example URL and do not bundle FFmpeg.
- Strict signature checking failed on the loose `.app` in the synced folder because of FinderInfo attributes. The same build's ZIP passed after extraction into an ordinary temporary directory.
- Source ZIP integrity passed. It exports only staged Git files, excluding private configuration and runtime data.
- GitHub Actions passed for commit `426f1f0`: server configuration checks, Mac self-check, app build and strict signature verification. [Run details](https://github.com/Ian-Wuu/screen-home-monitor/actions/runs/37125084050).

### Not verified or not included

- Docker CLI was unavailable locally; Compose containers and remote image pulls were not tested.
- The new Compose deployment has not passed end-to-end acceptance on a clean Linux host.
- This preparation did not retest Apple Home playback, cellular access, HomePod failover or a continuous two-hour session.
- The release does not include FFmpeg binaries, a notarized installer, personal accounts, Home pairing databases or automatic migration of an existing server.

### Historical installation feedback

In August 2026, the user confirmed Mac and Apple TV playback and remote viewing with Apple TV as the home hub. After repeated troubleshooting, iPhone LAN playback recovered when its proxy was disabled. This is a result from one environment, not a compatibility guarantee for every VPN, router or OS version.

---

## 中文

本次整理日期：2026-10-03。日期代表源码整理时间，不表示家中设备当天经过重新测试。

### 本地检查

- 配置生成自检：随机凭据生成、重复执行保留凭据、受限文件权限、非法主机名拒绝、损坏凭据拒绝通过。
- Compose、MediaMTX 模板、GitHub Actions YAML 语法解析通过；发布脚本和构建脚本语法检查通过。
- Git 忽略规则覆盖服务器私密文件、Scrypted 数据、FFmpeg 二进制、构建产物和本地环境文件。
- Mac 自检通过；Apple Silicon/macOS 13 目标编译通过。公开构建使用无凭据的示例地址，未内置 FFmpeg。
- 同步目录里的 `.app` 由于 FinderInfo 属性未通过严格签名检查；同一构建 ZIP 解压到普通临时目录后，严格签名校验通过。
- 源码 ZIP 完整性检查通过，只从 Git 暂存清单导出，不携带私密配置和运行时数据。
- 提交 `426f1f0` 的 GitHub Actions 已通过：服务器配置检查、Mac 自检、App 构建与严格签名验证。[运行记录](https://github.com/Ian-Wuu/screen-home-monitor/actions/runs/37125084050)。

### 没有验证或不包含

- 本机没有 Docker CLI；没有运行 Compose 容器或验证远端镜像拉取。
- 新 Compose 部署没有在全新 Linux 主机上完成端到端验收。
- 没有在本次整理中重新测试 Apple 家庭、蜂窝网络、HomePod 故障切换或连续两小时运行。
- 不包含 FFmpeg 二进制、公证后的安装程序、个人账号、家庭配对数据库或现有服务器自动迁移工具。

### 历史现场反馈

2026 年 8 月用户确认过 Mac 和 Apple TV 画面，以及 Apple TV 作为家庭中枢时的远程观看。iPhone 局域网连接经多轮排查后，在关闭手机代理时恢复。这是一次具体环境的使用结果，不等于对所有 VPN、路由器和系统版本的兼容性承诺。
