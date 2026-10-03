# 安全与隐私 / Security and privacy

中文 · [English](#english)

只分享你确实愿意公开给摄像头观看者的显示器。选中显示器上的全部内容，包括通知，都会出现在画面中。

本项目的 RTSP 通过 TCP 使用基本认证，没有 TLS 加密。仅在可信局域网使用，不要把 8554 端口或 Scrypted 管理界面转发到公网。远程观看通过 Apple 家庭与在线家庭中枢完成。

发布和读取使用分别随机生成的凭据。生成文件具有受限本地权限，并被 Git 忽略。Mac 将目的地 URL 保存于 UserDefaults，**不是钥匙串**；隐藏输入框不等于加密存储。进程参数和上游日志也可能包含凭据。这是个人局域网原型，不是经过加固的多用户服务。

不要上传私密配置、HomeKit 配对码或数据库、SSH 密钥、抓包文件，以及含 SRTP 密钥的日志。备份也应私密保存。不要在公开 issue 中附上秘密信息；请提供遮盖敏感内容后的诊断与问题描述。

## English

Only stream a display you intend to share. The entire selected display,
including notifications, is visible to authorized camera viewers.

RTSP here uses basic authentication over TCP without TLS. Use a trusted LAN;
do not forward port 8554 or the Scrypted admin interface to the Internet.
Remote viewing is provided by Apple Home and an online home hub.

Publish and read credentials are separate and randomly generated. Generated
files have restrictive local permissions and are excluded from Git. The Mac
stores its destination URL in UserDefaults, **not Keychain**; hiding a field
does not encrypt the value. Process arguments and upstream logs may also
contain credentials. This is a personal LAN prototype, not a hardened
multi-user service.

Never upload private configuration, HomeKit pairing codes or databases,
SSH keys, packet captures, or logs containing SRTP keys. Keep backups private.
Do not attach secrets to public issues; describe the symptom with redacted
diagnostics instead.
