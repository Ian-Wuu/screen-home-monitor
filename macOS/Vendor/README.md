# Optional FFmpeg bundle / 可选 FFmpeg 打包

[English](#english) · [中文](#中文)

## English

Source releases do not include FFmpeg binaries. The app normally locates a
locally installed FFmpeg at `/opt/homebrew/bin/ffmpeg` or `/usr/local/bin/ffmpeg`.

For a personal standalone build, put a compatible executable static arm64
FFmpeg at `macOS/Vendor/ffmpeg`, plus its matching license notice at
`macOS/Vendor/FFMPEG_LICENSE`. The build script copies them into the app.
Confirm that `ffmpeg -encoders` lists `h264_videotoolbox` and that the binary
does not depend on libraries available only on your build machine.

Before distributing that binary, review its actual build options, license,
and corresponding-source requirements. A generic FFmpeg notice is not proof
of compliance for a particular build. Do not commit vendor binaries here.

---

## 中文

源码发布不包含 FFmpeg 二进制。App 默认查找本机 `/opt/homebrew/bin/ffmpeg` 或 `/usr/local/bin/ffmpeg`。

若制作个人自用的一体包，将兼容的可执行静态 arm64 FFmpeg 放到 `macOS/Vendor/ffmpeg`，对应许可声明放到 `macOS/Vendor/FFMPEG_LICENSE`。构建脚本会将它们复制进 App。确认 `ffmpeg -encoders` 列出 `h264_videotoolbox`，且程序不依赖只在构建电脑上存在的库。

分发二进制前，检查其真实构建选项、许可和对应源码提供要求。通用 FFmpeg 声明不能证明某个具体构建符合许可要求。不要把第三方二进制提交到此仓库。
