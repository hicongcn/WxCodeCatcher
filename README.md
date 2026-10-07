# WxCodeCatcher — 微信授权回调 code 捕获壳

在 iOS 上点开 `weixin://app/wx3fea7a3c94a23944/auth/?scope=snsapi_userinfo&state=xxx`，
微信确认后回调的 code 会被这个 App 接住并显示/复制。

## 为什么需要它

微信授权 code 回调有两个目的地：
- **scheme** `wx3fea7a3c94a23944://oauth?code=xxx`
- **Universal Link** `https://<ele.me 系域名>/?code=xxx`（饿了么域名，第三方拿不到）

饿了么 App 装着时，微信优先把 code 还给饿了么，但饿了么因无 pending 会丢弃。
本 App 注册了同一个 scheme（`wx3fea7a3c94a23944`），**卸载饿了么后装本 App**，
微信回调就落到这里，直接拿 code。

## 编译（GitHub Actions 出未签名 IPA）

1. 新建 GitHub 仓库，把本目录全部 push 上去
2. Actions → "Build WxCodeCatcher IPA (unsigned)" → Run workflow
3. 跑完在 Artifacts 下载 `WxCodeCatcher-unsigned-ipa.zip` → 解压得 `.ipa`

## 自签安装（用你自己的证书）

- **TrollStore**（越狱/A14 以下特定系统）：直接安装 IPA
- **AltStore / Sideloadly**：用你的 Apple ID 免费证书签名安装
- **自己的开发者证书 + 描述文件**：用 `codesign`/`zsign`/`ios-signer` 重签
  ```bash
  zsign -k cert.p12 -p 密码 -m profile.mobileprovision -o signed.ipa WxCodeCatcher-unsigned.ipa
  ```

## 使用

1. 装好后，**先卸载饿了么 App**（否则微信优先回饿了么）
2. 用微信/浏览器打开授权链接：
   `weixin://app/wx3fea7a3c94a23944/auth/?scope=snsapi_userinfo&state=test123`
3. 微信确认页 → 允许
4. 自动跳回 CodeCatcher，显示 code（并已复制到剪贴板）

## 拿到 code 之后

```bash
python3 ele_code_login.py <code>
```
（ele_code_login.py 在 ../eleme/ 目录，用 code 直接换饿了么登录态）

## 注意

- **Universal Link 优先**：若微信走 UL 回跳（饿了么域名），本 App 接不到 scheme 回调。
  这种情况需要卸载饿了么后实测微信行为；若微信仍走 UL，需另行处理（DNS/hosts 不可行于 iOS）。
- Bundle ID `com.local.wxcode.catcher` 可按需改（自签时随意）。
- 编译不需要签名（CI 已关），装的时候才需要你的证书。
