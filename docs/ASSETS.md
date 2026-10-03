# Images and brand assets / 图片与品牌素材

[English](#english) · [中文](#中文)

## English

- `assets/logo.png`: generated and edited with the built-in imagegen tool at the user's request. Two offset, open screen outlines in black on white.
- `assets/menu.png` and `assets/settings.png`: local offscreen renders of the repository's actual SwiftUI components. These are not Apple Home live-stream screenshots and do not fake a successful Streaming state. Isolated sample preferences are used without reading the private RTSP destination.
- Regenerate the interface previews on Mac with `zsh macOS/scripts/render-previews.sh`.
- `assets/demo-tv.png` and `assets/demo-phone.png`: deterministic, hand-composited device demonstrations, not generated images. Device frames and simplified Home-style layouts are drawn in AppKit. The inset is `assets/demo-screen.png`, a native text render of public `macOS/Tests/SelfCheck.swift` and recorded local self-check output. It is sample content, not a live stream or an actual tvOS/iPhone screenshot.
- Rebuild the composites from the repository root with `swift scripts/compose-previews.swift`. The editable composition source is included. No private Home names, device lists, current screen content or connection details are published.

### Composition and boundaries

Plain off-white backgrounds, black device outlines and restrained type. There are no generated rooms, hands or lifestyle photographs. Both composites carry a visible disclosure. The earlier generated scene explorations were rejected and excluded from the repository. The previously approved logo remains the only generated asset in this release.

The GitHub introduction uses the root `README.md` and its images. The upload package contains no standalone website or GitHub Pages configuration. Earlier website designs are preserved in an archive outside the repository and are not published.

### Logo edit prompt

Preserve the double-screen composition, both open outlines, rounded corners, spacing and positions. Only change the strokes to black and increase their weight to approximately 1.5 times the original. Keep a white background with no text, shadows, gradients or additional decoration.

---

## 中文

- `assets/logo.png`：使用内置 imagegen 生成并按用户要求修改的标志：白底、黑色线条，两个错位的开放屏幕轮廓。
- `assets/menu.png`、`assets/settings.png`：使用仓库内真实 SwiftUI 组件在本机离屏渲染。不是 Apple 家庭直播截图，也没有伪造 Streaming 成功状态。使用独立的示例偏好设置，不读取私人 RTSP 目的地。
- 可在 Mac 上通过 `zsh macOS/scripts/render-previews.sh` 重新生成界面图。
- `assets/demo-tv.png`、`assets/demo-phone.png`：确定性的手工合成设备演示图，未使用图像生成。AppKit 绘制设备边框和简化的家庭风格布局，内部嵌入 `assets/demo-screen.png`，内容为公开的 `macOS/Tests/SelfCheck.swift` 及已记录的本地自检输出的原生文字渲染。它是示例内容，不是实时流或 tvOS／iPhone 真实截图。
- 在仓库根目录执行 `swift scripts/compose-previews.swift` 可重新合成，仓库附有可编辑的合成源码。不发布私人家庭名称、设备列表、当前屏幕内容或连接信息。

### 合成方式与边界

纯浅色底、黑色设备轮廓、简洁文字，没有生成式房间、手部或生活方式照片。两张图均带有明显的合成说明。此前生成的场景草案被弃用，不包含在仓库里；本次发布仅保留此前已认可的生成式 logo。

GitHub 仓库介绍使用根目录 `README.md` 的文字与图片。上传包不包含独立网页或 GitHub Pages 配置。早期网页设计保留在仓库外的设计归档目录，不参与发布。

### Logo 生成提示词

保留双屏版本的构图、两个开放轮廓、圆角、间距和位置，仅将线条改为黑色，并将笔画加粗到原来的约 1.5 倍。保持纯白背景；不增加文字、阴影、渐变或其他装饰。
