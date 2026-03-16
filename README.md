# iConnect

`iConnect` is an Apple-first SSH client built with Flutter for `iPhone` and `iPad`. It combines native `SSH` and `SFTP` access with a hybrid managed-access model for `Tailscale` and `Cloudflare` environments, while keeping the connection core in pure Dart so the app can grow into `Android` and `macOS` later.

The project is local-first. Server profiles, snippets, known hosts, and saved key metadata live on-device. Sensitive material such as private keys, passwords, and passphrases goes into iOS secure storage instead of SQLite.

## What the app does today

- Saves reusable server profiles with host, username, tags, default directory, terminal theme, and network mode
- Supports direct SSH, `ProxyJump` chains, and managed-access browser fallback flows
- Supports password, private key, and keyboard-interactive authentication
- Stores reusable SSH keys by ID so multiple servers can reference the same key material
- Generates new `Ed25519` keys in-app or imports existing private/public key pairs
- Persists trusted host fingerprints locally and blocks changed host keys until the user approves them
- Opens terminal tabs with `xterm`, including split view on wide layouts and a full-screen terminal mode
- Provides a basic remote file browser over `SFTP` with preview, upload, download, rename, delete, and folder creation
- Stores reusable command snippets with placeholder interpolation

## Current scope

Included in the current app:

- Local-only data model with no backend and no account system
- iPhone and iPad adaptive UI
- Drift-backed metadata persistence
- Keychain-backed secret storage
- Browser handoff for provider-managed console flows

Deliberately out of scope right now:

- `mosh`
- Cloud sync or iCloud sync
- Team/shared workspaces
- Embedded `cloudflared`, embedded VPN clients, or provider certificate issuance
- In-app text editing for remote files
- Persisted app preferences across launches

## Architecture at a glance

- `lib/main.dart`: Flutter entry point and `ProviderScope`
- `lib/app/app.dart`: root `MaterialApp.router`
- `lib/app/providers.dart`: dependency graph, app bootstrap, streams, router, and in-memory preferences/workspace controllers
- `lib/app/theme.dart`: app Material themes and terminal color presets
- `lib/data/app_database.dart`: Drift schema and SQLite file setup
- `lib/data/repositories.dart`: domain models plus the local repository layer
- `lib/services/connection_engine.dart`: SSH launch flow, host trust checks, jump-host chaining, shell sessions, and SFTP operations
- `lib/services/workspace_controller.dart`: terminal tab lifecycle and active session state
- `lib/services/secure_storage_service.dart`: secure storage and biometric unlock glue
- `lib/services/ssh_key_service.dart`: SSH key import, generation, normalization, and fingerprinting
- `lib/features/home_shell.dart`: adaptive shell and all top-level screens
- `lib/features/server_editor_sheet.dart`: server profile editor
- `lib/features/saved_key_editor_sheet.dart`: saved key generator/import UI

For a much deeper tour of every layer, read [INFO.md](INFO.md).

## Requirements

- Flutter stable
- Dart SDK compatible with the pinned Flutter version
- Xcode with an iOS simulator for Apple testing
- CocoaPods for iOS dependency installation

This project currently targets `iOS 17+`.

## Getting started

1. Clone the repository.
2. Ensure `flutter` is available on your `PATH`.
3. Install packages:

```bash
flutter pub get
```

4. If you change the Drift schema, regenerate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Running the app

Preferred development flow:

```bash
flutter run
```

If you want to target a specific simulator:

```bash
flutter devices
flutter run -d "<device id>"
```

Important iOS note:

- `flutter_secure_storage` uses Keychain access.
- For simulator testing that touches saved credentials, run the app through `flutter run` or Xcode so the app has the expected signing/entitlement context.
- An unsigned simulator artifact created with `flutter build ios --simulator --no-codesign` can install, but it is not reliable for Keychain-backed flows and may trigger the iOS `-34018` entitlement error.

## Verification

Run these before pushing changes:

```bash
flutter analyze
flutter test
```

There are also tests covering:

- profile validation
- snippet interpolation
- repository persistence behavior
- SSH key generation/import validation
- a shell-level UI smoke test

## Seed data

On a fresh database, the repository seeds demo content automatically:

- `Bastion`
- `Fleet Node`
- `Zero Trust Edge`
- sample snippets for log tailing and service restart

That seed only runs when the `server_profiles` table is empty.

## Security model

- Private keys, passwords, public keys, and passphrases are stored in secure storage
- Saved key metadata and profile references are stored in SQLite
- Known-host fingerprints are stored in SQLite and checked during connection
- Biometrics are opt-in per credential

## Contributing

When changing the app, keep these project rules in mind:

- Keep SSH/session logic in pure Dart under `lib/services`
- Keep platform-specific behavior behind small service wrappers
- Keep persistent app metadata in the repository layer, not in widget state
- Use saved key IDs rather than duplicating private key material across profiles
- Preserve the hybrid access model: native SSH when possible, browser fallback when the provider flow requires it

## Developer docs

The main deep-dive is in [INFO.md](INFO.md). It explains:

- startup flow and provider wiring
- every domain model and table
- secure storage layout
- connection lifecycle, including `ProxyJump`
- screen-by-screen UI structure
- testing strategy
- extension recipes and current limitations
