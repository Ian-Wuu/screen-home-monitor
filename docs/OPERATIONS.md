# Maintenance and publishing / 维护与发布

[English](#english) · [中文](#中文)

## English

### Service data and updates

`server/private/` holds generated credentials and MediaMTX configuration. `server/volume/` holds Scrypted accounts, plugins and Home pairing state. Back up both and never publish either. Stop Scrypted before copying its data directory for a consistent backup, then restart it. Deleting the volume loses pairing state.

Compose pins MediaMTX 1.18.2 and a previously used Scrypted lite image digest. These are reproducibility starting points, not claims of being current. Read upstream release notes and back up before upgrading. Scrypted plugins update independently; record and verify their versions separately.

Preparing this repository did not connect to or update the existing server. This Compose setup targets new deployments. For an existing server, inspect ports and data directories before choosing a migration approach.

References: [MediaMTX configuration](https://mediamtx.org/docs/references/configuration-file), [Scrypted HomeKit](https://docs.scrypted.app/homekit.html). Online documentation may describe newer versions than the pinned images.

### Mac builds and signing

```sh
zsh macOS/scripts/self-check.sh
AI_SIGN_IDENTITY='Your code-signing certificate name' zsh macOS/scripts/build.sh
```

Without an explicit identity, the script tries a local Apple Development certificate, otherwise ad-hoc signing. GitHub CI explicitly uses ad-hoc signing. It checks compilation, not Developer ID signing, notarization or screen-recording permission behavior.

Default builds do not bundle FFmpeg and use `/opt/homebrew/bin/ffmpeg` or `/usr/local/bin/ffmpeg`. For a personal standalone build, follow [the vendor notes](../macOS/Vendor/README.md). Do not upload an existing private app bundle: older builds may contain destination credentials.

Outputs are `dist/AI Screen Stream.app` and `dist/AI-Screen-Stream-macOS.zip`. FinderInfo extended attributes in cloud-synced/File Provider folders can invalidate signature checks. Prefer an ordinary local build directory and verify the extracted ZIP.

### Publishing to GitHub

Repository: [`Ian-Wuu/screen-home-monitor`](https://github.com/Ian-Wuu/screen-home-monitor).

- English description: Your Mac screen in Apple Home. A lightweight menu-bar monitor for Apple TV, iPhone and Mac.
- 中文介绍：把 Mac 屏幕接入 Apple 家庭，在 Apple TV、iPhone 和 Mac 上随时查看。

The root README provides the GitHub introduction with prose and two native interface previews. The focus is checking AI work while watching TV; there is no separate website or automatic task-state detection.

Publish the source, documentation, `server/`, `scripts/`, `macOS/` and `.github/`. Exclude `.git/` internals, `dist/`, `.build/`, `server/private/`, `server/volume/` and FFmpeg binaries. `scripts/package-source.sh` exports the Git staging index into a source ZIP, so stage intended changes before running it.

From the repository root, review staged files, commit, and replace `YOUR_ACCOUNT` with your account:

```sh
git status --short
git diff --cached --stat
git commit -m "Prepare Screen Home Monitor source release"
gh repo create YOUR_ACCOUNT/screen-home-monitor --public --source=. --remote=origin --push
```

Alternatively, create an empty GitHub repository and follow its push instructions. These commands are for publishing your own copy; cloning an existing repository already configures its origin remote.

The custom source-available license permits commercial works made with the tool but prohibits commercialization of the software or modified versions without separate permission. Do not label it MIT or standard open source. Existing permissions for the earlier MIT commit remain unaffected. External components retain their own terms; see [third-party notices](../THIRD_PARTY_NOTICES.md).

---

## 中文

### 服务数据与升级

`server/private/` 保存随机凭据与 MediaMTX 配置；`server/volume/` 保存 Scrypted 账号、插件和家庭配对状态。两者都必须备份、都不能上传。拷贝 Scrypted 数据目录前停止该服务以取得一致快照，备份后启动；删除 volume 会丢失配对状态。

Compose 固定 MediaMTX 1.18.2，以及历史使用过的 Scrypted lite 镜像摘要。它们是复现起点，不代表最新版本。修改镜像前阅读上游发布记录并备份；Scrypted 插件独立更新，需要另外记录和验证版本。

本次只整理仓库，没有连接或更新现有服务器。本 Compose 面向新部署；已存在服务器需人工检查端口和数据目录后选择迁移方式。

官方资料：[MediaMTX 配置](https://mediamtx.org/docs/references/configuration-file)、[Scrypted](https://docs.scrypted.app/homekit.html)。线上文档可能对应比此处镜像更新的版本。

### Mac 构建与签名

```sh
zsh macOS/scripts/self-check.sh
AI_SIGN_IDENTITY='你的代码签名证书名称' zsh macOS/scripts/build.sh
```

不设置签名身份时，脚本尝试本机 Apple Development 证书，否则 ad-hoc。GitHub CI 明确使用 ad-hoc；它检查源码编译，不代表完成 Developer ID 签名、公证或录屏授权测试。

默认构建不包含 FFmpeg，依赖 `/opt/homebrew/bin/ffmpeg` 或 `/usr/local/bin/ffmpeg`。若制作个人自用的一体包，可按 `macOS/Vendor/README.md` 加入兼容静态程序。不要直接上传现有私人安装包；旧包可能嵌入了目的地凭据。

输出为 `dist/AI Screen Stream.app` 和 `dist/AI-Screen-Stream-macOS.zip`。在云同步/File Provider 文件夹里，FinderInfo 扩展属性可能使签名校验失败；建议在普通本地目录构建并验证解压后的 ZIP。

### 上传 GitHub

仓库：[`Ian-Wuu/screen-home-monitor`](https://github.com/Ian-Wuu/screen-home-monitor)。介绍：把 Mac 屏幕接入 Apple 家庭，在 Apple TV、iPhone 和 Mac 上随时查看。

GitHub 首页使用根目录 README 的文字和两张原生界面预览图。核心场景是在看电视期间查看 Mac 上 AI 任务的画面，不包含独立网站或自动状态识别。

上传仓库根目录的源码、说明、`server/`、`scripts/`、`macOS/` 和 `.github/`。不要上传 `.git/` 内部文件、`dist/`、`.build/`、`server/private/`、`server/volume/` 或 FFmpeg 二进制。`scripts/package-source.sh` 会从 Git 暂存清单生成源码 ZIP。

若使用 Git，在仓库根目录检查暂存文件并提交，然后把 `YOUR_ACCOUNT` 替换成你的账号：

```sh
git status --short
git diff --cached --stat
git commit -m "Prepare Screen Home Monitor source release"
gh repo create YOUR_ACCOUNT/screen-home-monitor --public --source=. --remote=origin --push
```

也可以先在 GitHub 建立空仓库，再按 GitHub 给出的推送命令操作。以上命令用于发布你自己的副本；克隆已有仓库后，其 origin 远端已经配置好。

本仓库采用自定义源码可用许可：允许用工具做商业作品，禁止将软件本身或修改版做成商业产品或服务，除非另行取得授权。不要将其标为 MIT 或标准开源许可。早期 MIT 提交的既有授权不受影响。第三方组件另行适用其许可，见 `THIRD_PARTY_NOTICES.md`。
