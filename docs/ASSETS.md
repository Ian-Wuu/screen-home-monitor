# Images and brand assets / 图片与品牌素材

[English](#english) · [中文](#中文)

## English

- `assets/logo.png`: generated and edited with the built-in imagegen tool at the user's request. Two offset, open screen outlines in black on white.
- `assets/menu.png` and `assets/settings.png`: local offscreen renders of the repository's actual SwiftUI components. These are not Apple Home live-stream screenshots and do not fake a successful Streaming state. Isolated sample preferences are used without reading the private RTSP destination.
- Regenerate the interface previews on Mac with `zsh macOS/scripts/render-previews.sh`.
- `assets/home-chatgpt-demo.png`: a manual composite made from actual, locally captured macOS Home and ChatGPT UI screenshots. Native Home controls are preserved, while the unavailable camera area is replaced with the ChatGPT screenshot. The original camera was offline during capture; its status is explicitly replaced by `COMPOSITE`, not by a false Live/Connected indicator. This is not a live-playback test or an iPhone/tvOS screenshot.
- `assets/chatgpt-demo.png`: actual ChatGPT temporary-chat response to a deliberately public Python-example prompt. Browser tabs, address bar and the left navigation/profile rail are cropped out. No private conversation, Home name or device list is published.
- `scripts/compose-home-demo.swift` contains the editable crop and composition recipe. It requires two local screenshots; the unredacted originals remain outside the repository. Crop coordinates are checked against the captured dimensions before running.

### Composition and boundaries

The original UI pixels are used, not hand-drawn approximations. The composite carries a visible disclosure. Earlier generated scenes and simplified device mockups were rejected and removed from the current release; historical Git commits may still contain the latter. The approved logo is the only generated image in this release.

Apple's [Home overview](https://www.apple.com/home-app/) and [TV camera guide](https://support.apple.com/guide/tv/atvb90537bb0/tvos) were consulted as references. Their promotional images are not included. See Apple's [image and trademark guidelines](https://www.apple.com/legal/intellectual-property/guidelinesfor3rdparties.html). Apple and OpenAI retain rights in their respective interfaces and marks; those UI portions are not relicensed under this project's source license. No endorsement is implied.

The GitHub introduction uses the root `README.md` and its images. The upload package contains no standalone website or GitHub Pages configuration. Earlier website designs are preserved in an archive outside the repository and are not published.

### Logo edit prompt

Preserve the double-screen composition, both open outlines, rounded corners, spacing and positions. Only change the strokes to black and increase their weight to approximately 1.5 times the original. Keep a white background with no text, shadows, gradients or additional decoration.

---

## 中文

- `assets/logo.png`：使用内置 imagegen 生成并按用户要求修改的标志：白底、黑色线条，两个错位的开放屏幕轮廓。
- `assets/menu.png`、`assets/settings.png`：使用仓库内真实 SwiftUI 组件在本机离屏渲染。不是 Apple 家庭直播截图，也没有伪造 Streaming 成功状态。使用独立的示例偏好设置，不读取私人 RTSP 目的地。
- 可在 Mac 上通过 `zsh macOS/scripts/render-previews.sh` 重新生成界面图。
- `assets/home-chatgpt-demo.png`：基于本机实际截取的 macOS 家庭与 ChatGPT 界面进行手工合成，保留原生家庭控件，只将不可用的视频区域换成 ChatGPT 截图。截取时摄像头离线，因此状态明确改为 `COMPOSITE`，没有伪造“实时／已连接”标记。这不是播放测试或 iPhone／tvOS 截图。
- `assets/chatgpt-demo.png`：真实 ChatGPT 临时对话回复，提示词为专门准备的公开 Python 示例。已裁掉浏览器标签、地址栏和左侧导航／个人资料栏，不包含私人对话、家庭名称或设备列表。
- `scripts/compose-home-demo.swift` 是可编辑的裁切与合成脚本，需要两张本地截图。未脱敏原图保留在仓库外，运行时会检查截图尺寸是否匹配裁切坐标。

### 合成方式与边界

使用原始界面像素，不手绘近似 UI，合成图带有明显说明。之前的生成式场景与简化设备框已弃用并移出当前版本，历史 Git 提交仍可能含有后者。当前发布只有已认可的 logo 是生成式图片。

参考了 Apple 的[家庭介绍](https://www.apple.com/home-app/)与 [TV 摄像头指南](https://support.apple.com/guide/tv/atvb90537bb0/tvos)，未将其宣传图收录进仓库。参见 Apple 的[图片和商标指南](https://www.apple.com/legal/intellectual-property/guidelinesfor3rdparties.html)。Apple 和 OpenAI 保留各自界面与商标权利，界面部分不按本项目源码许可重新授权，也不表示官方认可。

GitHub 仓库介绍使用根目录 `README.md` 的文字与图片。上传包不包含独立网页或 GitHub Pages 配置。早期网页设计保留在仓库外的设计归档目录，不参与发布。

### Logo 生成提示词

保留双屏版本的构图、两个开放轮廓、圆角、间距和位置，仅将线条改为黑色，并将笔画加粗到原来的约 1.5 倍。保持纯白背景；不增加文字、阴影、渐变或其他装饰。
