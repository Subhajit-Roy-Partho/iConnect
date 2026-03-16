# iConnect

Apple-first SSH client built with Flutter for `iPhone` and `iPad`, with a pure-Dart SSH core that can grow into `Android` and `macOS` later.

## What’s implemented

- Adaptive Flutter shell with sections for `Servers`, `Sessions`, `Files`, `Snippets`, and `Settings`
- Local-first profile storage with `Drift` and secure credential storage with `flutter_secure_storage`
- SSH terminal sessions powered by `dartssh2` and `xterm`
- `ProxyJump` chaining through saved jump profiles
- Hybrid managed-access model for `Tailscale` and `Cloudflare` browser-backed flows
- Basic `SFTP` browser with preview, upload, download, rename, delete, and folder creation
- Snippet interpolation, known-host trust store, biometric-gated credential unlock, and split-session support

## Project structure

- `lib/app`: app bootstrap, providers, routing, and theming
- `lib/data`: Drift schema plus repositories and domain models
- `lib/services`: SSH engine, workspace controller, browser launcher, and secure storage
- `lib/features`: app shell, server editor, and section UIs
- `lib/core`: validation and snippet interpolation helpers

## Run

```bash
/Users/subhajitrouy/.local/flutter-release/flutter/bin/flutter pub get
/Users/subhajitrouy/.local/flutter-release/flutter/bin/flutter run
```

## Verify

```bash
/Users/subhajitrouy/.local/flutter-release/flutter/bin/flutter analyze
/Users/subhajitrouy/.local/flutter-release/flutter/bin/flutter test
/Users/subhajitrouy/.local/flutter-release/flutter/bin/flutter build ios --simulator --debug --no-codesign
```
