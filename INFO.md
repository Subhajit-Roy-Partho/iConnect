# iConnect Developer Documentation

This document is the detailed implementation guide for `iConnect`. It is written for someone who needs to understand, debug, or extend the project without reverse-engineering the codebase first.

The app is a Flutter-based SSH client aimed at `iPhone` and `iPad`. It is intentionally organized so that the hard parts of the product such as session launch, host trust, SFTP, and saved key handling live in portable Dart code, while platform-specific behavior stays at the edge.

## 1. Product intent

The project is trying to solve a fairly specific problem:

- provide a modern mobile SSH client experience on Apple devices
- support traditional SSH servers and file access over `SFTP`
- support complex routing via `ProxyJump`
- support enterprise-style access paths where the user may reach the host over `Tailscale`, `Cloudflare WARP`, or a browser-rendered provider console
- keep secrets on-device and avoid introducing a backend too early

That drives several architectural choices:

- metadata is stored locally in SQLite with `Drift`
- secrets are stored separately in secure storage
- the app has no server-side account model
- connection/session logic is pure Dart instead of platform-channel-heavy
- managed access is modeled as a hybrid flow rather than trying to fully embed every provider-specific product

## 2. Repository map

Top-level project areas:

- `lib/main.dart`: bootstraps Flutter and Riverpod
- `lib/app/`: app composition, provider setup, routing, theming
- `lib/data/`: Drift tables plus the app repository and domain objects
- `lib/services/`: SSH engine, secure storage, browser launch, key management, workspace/session state
- `lib/features/`: UI shell and modal editors
- `lib/core/`: small pure helpers such as validation and snippet rendering
- `test/`: unit and widget/smoke coverage
- `ios/`: Xcode project, entitlements, platform configuration

Important files to know first:

- `lib/app/providers.dart`
- `lib/data/repositories.dart`
- `lib/services/connection_engine.dart`
- `lib/services/workspace_controller.dart`
- `lib/features/home_shell.dart`

If you understand those five files, you understand most of the app.

## 3. Technology choices

The current stack is:

- `Flutter`: UI, routing, cross-platform structure
- `flutter_riverpod`: dependency injection and app state wiring
- `go_router`: top-level navigation between sections
- `drift` + `sqlite3_flutter_libs`: local relational persistence
- `flutter_secure_storage`: secret storage
- `local_auth`: biometric gating for credentials
- `dartssh2`: SSH, shell sessions, key parsing, port forwarding, SFTP
- `xterm`: terminal rendering
- `file_picker`: upload selection
- `url_launcher`: system browser handoff
- `pinenacl`: Ed25519 key generation

Why this matters:

- `dartssh2` makes it possible to keep all session logic in Dart
- `Drift` gives structure and testability to the metadata model
- secure storage stays separate from the relational store, which is important for key material
- Riverpod keeps service wiring centralized instead of scattering singletons through the UI

## 4. Startup flow

The app startup path is short and deliberate.

### 4.1 `lib/main.dart`

`main()` does two things:

- calls `WidgetsFlutterBinding.ensureInitialized()`
- wraps the app in `ProviderScope`

That means all state and dependencies are resolved through Riverpod from the first frame.

### 4.2 `lib/app/app.dart`

`IConnectApp` watches:

- `routerProvider`
- `appPreferencesProvider`

It builds a `MaterialApp.router` with:

- `title: 'iConnect'`
- `debugShowCheckedModeBanner: false`
- a light theme from `AppTheme.light()`
- a dark theme from `AppTheme.dark()`
- `themeMode` driven by app preferences

### 4.3 `lib/app/providers.dart`

This file is the dependency graph of the app.

It creates providers for:

- `AppDatabase`
- `SecureStorageService`
- `BiometricService`
- `BrowserLauncher`
- `SshKeyService`
- `AppRepository`
- `ConnectionEngine`
- stream-based views of profiles, snippets, saved keys, and known hosts
- `AppPreferencesController`
- `WorkspaceController`
- `GoRouter`

The bootstrap provider is:

- `appBootstrapProvider`

That provider calls `AppRepository.initialize()`. The UI shell waits on it before drawing the actual sections.

### 4.4 Router layout

The router is intentionally simple.

Routes:

- `/servers`
- `/sessions`
- `/files`
- `/snippets`
- `/settings`

The root path `/` redirects to `/servers`.

Each route renders the same `HomeShell` with a different `AppSection` enum value.

This means the app is really one shell with five section views, not five separate feature trees.

## 5. Theme and visual system

`lib/app/theme.dart` defines two layers of visual styling.

### 5.1 Material theme

There are app-wide Material themes:

- `AppTheme.light()`
- `AppTheme.dark()`

Both use seeded color schemes and Material 3. The project is using rounded surfaces heavily, with large radii and low-elevation cards.

### 5.2 Terminal themes

The terminal itself has a separate theme map:

- `TerminalThemePreset.midnight`
- `TerminalThemePreset.glacier`
- `TerminalThemePreset.daybreak`

These are not just app skin choices. They are stored on each server profile and applied to the terminal renderer when that profile opens.

If you add a new terminal theme:

1. add the enum value in `repositories.dart`
2. add the theme instance in `theme.dart`
3. expose it in the server editor UI

## 6. Data model and persistence

The project separates persistent state into three buckets:

- SQLite metadata
- secure storage secrets
- in-memory UI/session state

That separation is one of the most important design decisions in the codebase.

### 6.1 SQLite metadata

The SQLite database is defined in `lib/data/app_database.dart`.

The database file is created at:

- application documents directory + `i_connect.sqlite`

The schema version is currently:

- `1`

Foreign keys are enabled with:

- `PRAGMA foreign_keys = ON`

Current tables:

- `ServerProfiles`
- `JumpHops`
- `CredentialRefs`
- `PortForwardProfiles`
- `Snippets`
- `KnownHosts`

### 6.2 Table responsibilities

#### `ServerProfiles`

Stores stable metadata for a host profile:

- `id`
- `label`
- `host`
- `port`
- `username`
- `tagsJson`
- `defaultDirectory`
- `terminalTheme`
- `authMethod`
- `credentialRefId`
- `networkMode`
- `managedBrowserUrl`
- `managedTargetHint`
- `preflightRequirementsJson`
- `createdAt`
- `updatedAt`

This is the central record everything else hangs off.

#### `JumpHops`

Stores ordered jump-host edges:

- `profileId`
- `hopOrder`
- `hopProfileId`

This is how `ProxyJump` is represented. The profile stores the destination, and `JumpHops` stores the ordered chain to reach it.

#### `CredentialRefs`

Stores non-secret metadata about saved credentials:

- `id`
- `label`
- `kind`
- `usernameHint`
- `requiresBiometric`
- `publicKeyFingerprint`
- `isEncrypted`
- `createdAt`

Important: this table does not contain private key PEM, passwords, or passphrases. It only stores references and metadata.

#### `PortForwardProfiles`

Stores saved forward definitions:

- `id`
- `profileId`
- `kind`
- `bindHost`
- `bindPort`
- `targetHost`
- `targetPort`
- `autoStart`
- `label`

The UI stores and displays these, but the current session engine does not yet automatically apply them when a session starts. This is a stored capability and extension point more than a fully surfaced runtime feature right now.

#### `Snippets`

Stores reusable command entries:

- `id`
- `title`
- `shellText`
- `placeholdersJson`
- `workingDirectoryHint`
- `isFavorite`
- `lastUsedAt`
- `createdAt`

#### `KnownHosts`

Stores approved host key fingerprints:

- `id`
- `host`
- `port`
- `keyType`
- `fingerprintHex`
- `createdAt`
- `updatedAt`

This is the local trust store used during connection verification.

### 6.3 Domain enums

These live in `lib/data/repositories.dart`.

#### `AuthMethod`

- `password`
- `privateKey`
- `keyboardInteractive`

#### `NetworkMode`

- `direct`
- `tailscaleNetwork`
- `tailscaleConsole`
- `cloudflareWarp`
- `cloudflareBrowser`

These modes are used for behavior and for UX hints. They are not all equivalent to different transport implementations.

Important nuance:

- `direct`, `tailscaleNetwork`, and `cloudflareWarp` are native SSH paths
- `tailscaleConsole` and `cloudflareBrowser` are browser-fallback paths

That behavior is encoded in `ServerProfile.usesBrowserFallback`.

#### `CredentialKind`

- `password`
- `privateKey`
- `passphrase`

In practice, the saved key UI primarily produces `privateKey` credentials. Password and passphrase handling are still supported by the model and secure storage service.

#### `PortForwardKind`

- `local`
- `remote`

#### `TerminalThemePreset`

- `midnight`
- `glacier`
- `daybreak`

#### `PreflightRequirement`

- `warpClient`
- `tailscaleClient`
- `browserSignIn`
- `knownHostReview`

These are advisory metadata used to explain the expected environment for a managed profile.

### 6.4 Domain classes

All major domain objects are plain Dart value types with `copyWith()` support.

#### `CredentialRef`

Represents a saved credential reference. It is intentionally metadata-only.

Notable fields:

- `id`: the stable identifier other records store
- `label`: human-readable name
- `requiresBiometric`: whether access should prompt via `local_auth`
- `publicKeyFingerprint`: shown in the UI for saved SSH keys
- `isEncrypted`: whether the private key PEM itself is encrypted

#### `ManagedAccessConfig`

Represents extra access instructions tied to `NetworkMode`.

Fields:

- `mode`
- `browserUrl`
- `targetHint`
- `preflightRequirements`

#### `JumpRoute`

Represents ordered jump profile IDs for a destination server.

Fields:

- `profileId`
- `hopProfileIds`

#### `PortForwardProfile`

Represents a saved local or remote port forward definition.

#### `Snippet`

Represents a reusable shell command. Placeholder variables are stored separately from the rendered command text.

#### `KnownHostEntry`

Represents one trusted fingerprint entry.

#### `ServerProfile`

Represents the full connectable definition.

Key fields:

- `label`
- `host`
- `port`
- `username`
- `tags`
- `defaultDirectory`
- `terminalTheme`
- `authMethod`
- `credentialRef`
- `networkMode`
- `managedAccessConfig`
- `jumpRoute`
- `portForwards`

The most important computed property is:

- `usesBrowserFallback`

That flips the runtime from native SSH launch to browser handoff.

## 7. Repository layer

The repository lives in `lib/data/repositories.dart` as `AppRepository`.

This class is doing more than simple CRUD. It is the bridge between raw Drift rows and the domain model used everywhere else.

### 7.1 Initialization

`initialize()`:

- guards against double initialization
- optionally seeds demo data
- emits initial stream values

Because `watchProfiles()`, `watchSnippets()`, `watchSavedKeys()`, and `watchKnownHosts()` all call `initialize()`, most consumers do not need to think about bootstrap sequencing directly.

### 7.2 Stream model

The repository exposes broadcast stream controllers for:

- profiles
- snippets
- credentials
- known hosts

This app does not use live Drift query streams directly. Instead, it uses repository-owned streams and manual re-emission after writes. That makes the mapping layer explicit and keeps the rest of the app speaking in domain objects instead of generated row classes.

### 7.3 Profile reads

`getProfiles()` pulls data from multiple tables:

- profile rows
- credential rows
- jump hops
- port forwards

It then joins them into `ServerProfile` objects.

Important behavior:

- jump hops are grouped by `profileId` and ordered by `hopOrder`
- credentials are looked up by `credentialRefId`
- managed access config is reconstructed from profile fields
- tags and preflight requirements are stored as JSON arrays in the database and decoded into Dart lists

### 7.4 Profile writes

`saveProfile()` is transactional and does several things:

1. upserts the referenced credential metadata if one exists
2. upserts the `ServerProfiles` row
3. deletes and recreates all `JumpHops` for that profile
4. deletes and recreates all `PortForwardProfiles` for that profile
5. emits refreshed profiles and credentials

The delete-and-reinsert pattern is simple and reliable for ordered child collections like jump hops and port forwards.

### 7.5 Credential writes

`saveCredential()` only stores metadata in SQLite. It does not touch the secure storage payload. That split is intentional.

The caller is responsible for writing:

- private key PEM
- password
- public key text
- passphrase

through `SecureStorageService`.

### 7.6 Credential deletion

There are two relevant deletion behaviors:

- deleting a credential ref removes its metadata row
- deleting a profile does not automatically delete shared saved keys

That second rule matters. The app treats saved keys as reusable assets, not embedded per-profile secrets.

### 7.7 Known hosts

The repository can:

- look up a known host by `host`, `port`, and `keyType`
- insert or replace a known host fingerprint
- delete known host entries

When a host key changes and the user explicitly re-trusts it, the repository updates the existing stored fingerprint.

### 7.8 Demo seed content

`seedDemoData()` inserts default content only if the server profile table is empty.

Current seeded profiles:

- `Bastion`
- `Fleet Node`
- `Zero Trust Edge`

Current seeded snippets:

- `Tail system log`
- `Restart service`

The seed data is useful for UI development and smoke testing, but it also means first-launch screenshots and tests may not start from a blank state unless you clear app data.

## 8. Secure storage model

Secrets are handled in `lib/services/secure_storage_service.dart`.

### 8.1 Storage keys

For each credential ID, secure storage may contain:

- `credential:<id>:primary`
- `credential:<id>:public`
- `credential:<id>:passphrase`

That means one credential reference can point to:

- a password
- a private key PEM
- a stored public key copy
- an optional passphrase

depending on how the feature is being used.

### 8.2 Why the public key is stored too

The public key is not required to authenticate an SSH connection. The private key is enough for client-side signing.

The public key is still stored because it is valuable for UX:

- copying into `authorized_keys`
- displaying or sharing from the app
- showing fingerprints and verifying imported/generated key identity

### 8.3 Biometric gating

`BiometricService.unlockIfNeeded()` wraps `local_auth`.

Behavior:

- if biometric unlock is not required, it returns `true`
- if required, it checks whether the device can authenticate
- then it prompts with `Unlock your SSH credentials`
- it returns `false` on unsupported devices, cancellation, or platform exceptions

This is a gate before reading the secure material, not encryption layered on top of SQLite.

### 8.4 iOS entitlement note

The iOS project includes:

- `ios/Runner/DebugProfile.entitlements`
- `ios/Runner/Release.entitlements`

These matter because secure storage and Keychain access can fail with iOS error `-34018` when the app is installed without the proper entitlement/signing context.

For real credential testing, run through:

- `flutter run`
- or Xcode

Do not treat an unsigned simulator build as an authoritative secure-storage test.

## 9. SSH key management

SSH key operations live in `lib/services/ssh_key_service.dart`.

This service is purely about key material validation, generation, normalization, and metadata derivation.

### 9.1 `SavedKeyMaterial`

Represents the complete result of creating or importing a reusable saved key:

- `credential`
- `privateKeyPem`
- `publicKey`
- `passphrase`

The `credential` is what gets persisted to SQLite. The key strings are what get written to secure storage.

### 9.2 Import flow

`importKey()`:

1. trims and validates the private key PEM
2. normalizes the optional passphrase
3. derives the public key from the private key
4. normalizes the provided public key if one was supplied
5. compares the provided public key against the derived public key
6. builds a `CredentialRef` with fingerprint and encryption metadata

This is what ensures the app can safely accept both private key and public key input while rejecting mismatches.

### 9.3 Key generation

`generateEd25519()`:

- generates a new Ed25519 signing key via `pinenacl`
- wraps it in `OpenSSHEd25519KeyPair`
- exports a PEM private key
- builds an OpenSSH-format public key line
- returns `SavedKeyMaterial`

This is the current in-app key generation path.

### 9.4 Public key normalization and fingerprinting

The service also provides:

- `publicKeyForPrivateKey()`
- `normalizePublicKey()`
- `fingerprintPublicKey()`

Fingerprints are currently:

- SHA-256 in OpenSSH-style `SHA256:...` format for saved public keys

### 9.5 Error model

Failures use `SshKeyException`.

Typical reasons:

- invalid PEM
- unsupported key format
- wrong passphrase
- mismatched public key
- invalid public key base64

The UI catches these and shows them in snack bars.

## 10. Connection engine

The core runtime logic lives in `lib/services/connection_engine.dart`.

This is the most important service in the app.

### 10.1 Main responsibilities

`ConnectionEngine` currently owns:

- deciding between native SSH and browser fallback
- loading secure credentials
- gating access behind biometrics when required
- verifying host keys
- building multi-hop `ProxyJump` chains
- opening interactive shell sessions
- exposing an attached `ConnectedSession` wrapper for terminal and SFTP usage

### 10.2 Launch decision

`launch(profile, hostTrustDelegate: ...)` starts by checking `profile.usesBrowserFallback`.

If `true`:

- a `BrowserLaunchIntent` is returned
- no native SSH socket is created

If `false`:

- a terminal instance is created
- jump profiles are loaded
- sockets and clients are created hop by hop
- the destination client opens an interactive shell
- a `ConnectedSession` is returned

### 10.3 Browser fallback path

The browser path exists for:

- `NetworkMode.tailscaleConsole`
- `NetworkMode.cloudflareBrowser`

The profile must contain a browser URL in `managedAccessConfig.browserUrl`.

The launch result is:

- `BrowserSessionLaunchResult`

The actual browser open happens separately through `openBrowser()`, which delegates to `BrowserLauncher`.

This split is useful because it allows the workspace controller to create a tab representing the browser-backed session even if the browser could not be opened automatically.

### 10.4 Native SSH path

The native path creates a socket and one or more `SSHClient` instances.

Sequence:

1. open a socket to either the destination host or the first jump host
2. connect/authenticate to the first hop
3. use `forwardLocal(nextHost, nextPort)` to get a socket-like tunnel to the next hop
4. repeat until the destination is reached
5. authenticate to the destination profile
6. request a shell with a PTY sized from the terminal viewport

This is how `ProxyJump` is implemented without shelling out to an external SSH binary.

### 10.5 Authentication behavior

`_connectClient()` reads the `CredentialRef` from the profile.

If present:

- it checks biometrics if required
- reads the primary secret from secure storage
- reads the passphrase if any

Auth-method behavior:

- `privateKey`: builds `SSHKeyPair.fromPem(secret, passphrase)`
- `password`: returns the primary secret when `onPasswordRequest` is triggered
- `keyboardInteractive`: fills all prompts with the same stored secret

That keyboard-interactive implementation is deliberately simple. It works for one-secret challenge flows but is not yet a full prompt-specific answer engine.

### 10.6 Host key verification

Host trust is controlled through the `HostTrustDelegate` interface.

The engine asks the repository for an existing known host by:

- `host`
- `port`
- `keyType`

Cases:

- no entry: ask `approveUnknownHost()`
- exact match: allow connection silently
- mismatch: ask `approveChangedHostKey()`

If the user approves either a new or changed key, the repository updates `KnownHosts`.

This gives the app a strict local trust model similar to `known_hosts`.

### 10.7 `ConnectedSession`

`ConnectedSession` is the runtime wrapper returned for native sessions.

It owns:

- the `ServerProfile`
- the authenticated destination `SSHClient`
- the open `SSHSession`
- the `Terminal`
- the list of jump clients used to reach the destination
- a lazily-created `SftpClient`

### 10.8 Terminal wiring

In the constructor, `ConnectedSession` wires the terminal bidirectionally:

- terminal output writes to the SSH shell
- terminal resize events call `shell.resizeTerminal(...)`
- shell stdout/stderr streams write back into the terminal buffer

This is the central bridge between `xterm` and `dartssh2`.

### 10.9 File operations

`ConnectedSession` also exposes the SFTP-backed file operations used by the Files screen:

- `listDirectory()`
- `resolveDirectory()`
- `createDirectory()`
- `deletePath()`
- `renamePath()`
- `uploadIntoDirectory()`
- `downloadToDocuments()`
- `readPreviewBytes()`

Important behavior:

- the SFTP client is lazy and cached
- `listDirectory()` hides `.` and `..`
- uploads use `file_picker` with in-memory bytes
- downloads currently write into the app documents directory using the remote file name
- previews cap reads at `32768` bytes by default

### 10.10 Session closure

`close()`:

- cancels stdout/stderr subscriptions
- closes the SFTP client if it exists
- closes the shell
- closes the destination client
- closes jump clients in reverse order

Closing in reverse order for jump clients is the right lifecycle because the final tunnel depends on the earlier hops.

## 11. Workspace/session state

Runtime workspace state lives in `lib/services/workspace_controller.dart`.

This state is intentionally in-memory only.

If the app is terminated:

- open tabs are gone
- active sessions are gone
- split/focus state is gone

That is current behavior, not a bug.

### 11.1 `WorkspaceTabStatus`

Possible values:

- `connecting`
- `connected`
- `browserFallback`
- `error`

### 11.2 `WorkspaceTab`

Represents one open tab.

Fields include:

- `id`
- `profile`
- `terminal`
- `status`
- `session`
- `browserIntent`
- `message`

The tab is created before the connection completes so the user sees immediate feedback.

### 11.3 `WorkspaceState`

Contains:

- `tabs`
- `activeTabId`
- `splitViewEnabled`
- `terminalFocusMode`

### 11.4 `connectProfile()`

This is the orchestrator method used by the UI.

Behavior:

1. if the profile is already open, it just activates the existing tab
2. otherwise it creates a new terminal and a `connecting` tab
3. it calls `ConnectionEngine.launch(...)`
4. if a native session comes back, it swaps the tab into `connected`
5. if a browser result comes back, it attempts browser launch and swaps the tab into `browserFallback`
6. if anything throws, it writes the error into the terminal and marks the tab `error`

This method is a key boundary between UI interaction and the lower-level connection service.

### 11.5 Other workspace actions

- `closeTab()`: disposes the session if needed, removes the tab, and updates the active tab
- `selectTab()`: activates a tab
- `toggleSplitView()`: toggles side-by-side terminals
- `toggleTerminalFocusMode()`: enters or exits immersive terminal mode
- `runSnippet()`: sends shell text to the active native session

## 12. UI structure

Most of the UI is in `lib/features/home_shell.dart`.

This file is large because it intentionally co-locates the section views for a fairly small app. The split is not yet one-file-per-screen.

### 12.1 `HomeShell`

`HomeShell`:

- waits for `appBootstrapProvider`
- reads the workspace state
- decides whether the current view should be immersive full-screen terminal mode
- picks `NavigationRail` for wide layouts and `NavigationBar` for compact layouts
- optionally shows an inspector panel on very wide screens

Breakpoints:

- `>= 1100`: wide shell with navigation rail
- `>= 1420`: show the inspector panel

### 12.2 `_SectionViewport`

Maps the current `AppSection` to one of the top-level screen widgets:

- `_ServersPage`
- `_SessionsPage`
- `_FilesPage`
- `_SnippetsPage`
- `_SettingsPage`

Outside immersive session mode, the content is wrapped in `SafeArea`.

### 12.3 `_InspectorPanel`

Only shown on extra-wide layouts.

It summarizes:

- server count
- open session count
- snippet count
- active focus message

It is mostly a productivity/dashboard affordance for larger screens.

### 12.4 `_PageHeader`

This small widget matters more than it looks.

It solves the top-of-page layout for every section and now adapts when width is narrow:

- wide layouts place the action on the right
- compact layouts stack the action below the text

This change is what fixed the file page overflow on narrow phones.

## 13. Servers screen

The Servers screen is `_ServersPage`.

Responsibilities:

- watch `profilesProvider`
- watch `savedKeysProvider`
- list all saved server profiles
- show tags, auth mode, network mode, jump count, and saved key badge
- open the editor
- delete a profile
- launch a connection

### 13.1 Connect action

Tapping `Connect`:

- calls `WorkspaceController.connectProfile(...)`
- passes a `_MaterialHostTrustDelegate`
- navigates to the Sessions section after the request starts

### 13.2 Editor flow

The page uses `ServerEditorSheet` in a bottom sheet.

When the sheet returns:

1. any newly created saved keys are persisted
2. the profile is saved through the repository
3. any inline secret/passphrase values are written into secure storage

This is an important pattern in the codebase:

- editor UIs return domain-oriented results
- pages orchestrate persistence

That keeps widgets relatively dumb and keeps storage policy visible at the page layer.

## 14. Server editor

The server editor lives in `lib/features/server_editor_sheet.dart`.

This is the most important form in the app.

### 14.1 High-level sections

The form is organized into:

- `Identity`
- `Access`
- `Managed access`
- `ProxyJump`
- `Port forwards`

The exact layout may evolve, but the model behind it already spans those concerns.

### 14.2 Identity fields

- display name
- host
- port
- username
- tags
- default directory

### 14.3 Access fields

- auth method
- network mode
- terminal theme
- saved key selection when using private-key auth
- inline secret inputs for non-key auth flows or new secret material
- biometric requirement toggle

### 14.4 Managed access fields

- browser URL
- target hint

These become relevant for browser-backed modes and for user guidance.

### 14.5 ProxyJump handling

The editor receives `availableProfiles` and lets the user choose saved profiles as hops.

The resulting `JumpRoute` stores only hop IDs. The actual resolution to profiles happens at connection time in the repository and engine.

### 14.6 Port forwards

The editor captures forward definitions as drafts and serializes them into `PortForwardProfile` objects on save.

Again, these are persisted and displayed, but they are not yet auto-started by the runtime session engine.

### 14.7 Validation

Validation uses `ServerProfileValidator` from `lib/core/server_profile_validator.dart`.

Current validation rules include:

- label required
- host required
- username required
- port must be numeric and within range
- browser URL required for managed browser modes

If you expand the server model, update validator coverage and tests at the same time.

## 15. Sessions screen

The Sessions screen is `_SessionsPage`.

Responsibilities:

- show open tabs
- show terminal panels or browser fallback panels
- manage split layout
- manage full-screen terminal mode

### 15.1 Empty state

When there are no tabs, it shows a prompt to connect from the Servers section.

### 15.2 Tab strip

Each open tab is shown as a `FilterChip` with:

- a label
- a status icon
- activation on tap
- close action

### 15.3 Split view

Split view requires:

- the user preference `splitSessions` to be true
- workspace split view to be enabled
- width of at least `1200`
- at least two tabs

This distinction between preference and runtime toggle is intentional:

- the setting expresses whether the feature is globally allowed
- the workspace toggle expresses whether the current session view wants it active

### 15.4 Full-screen terminal mode

When `terminalFocusMode` is true and there is an active tab:

- the shell hides the normal app chrome
- the active terminal fills the screen
- a floating top row shows the profile label and an `Exit Full Screen` button

This behavior is session-specific and handled entirely in the shell/workspace layer.

### 15.5 `_TerminalPanel`

This widget renders either:

- a `TerminalView`
- or `_BrowserFallbackView`

If not fullscreen, it wraps the content in a rounded card with:

- title
- message/target hint
- clipped terminal area

## 16. Browser fallback view

`_BrowserFallbackView` exists to represent non-native sessions inside the same tab model.

It shows:

- explanatory text
- the launch reason
- an `Open Again` button

This is useful because the app still needs a visible session artifact even when the real console is outside the app in Safari or another browser.

## 17. Files screen

The Files screen is `_FilesPage`, a `ConsumerStatefulWidget`.

This screen depends on the active native session from the workspace.

### 17.1 Why it is stateful

The screen needs local mutable state for:

- the currently attached `ConnectedSession`
- current path
- loading flag
- error value
- current directory listing

This is short-lived view state, so keeping it inside the widget is reasonable.

### 17.2 Session attachment behavior

On each build, the widget compares the active workspace session to its stored `_session`.

If it changed:

- it swaps the tracked session
- resets `_currentPath` to the session starting directory
- kicks off `_refresh()`

This is a compact pattern, though if the screen grows further it may be worth extracting into a dedicated controller/notifier.

### 17.3 Toolbar actions

The Files header action uses `OverflowBar`, which is important for compact phones.

Available actions:

- refresh
- go up
- create folder
- upload

The `OverflowBar` change fixed the narrow-device overflow bug where actions previously forced a single-row layout.

### 17.4 Directory list

The main body is a decorated container showing:

- empty state if there is no active native session
- loading spinner while reading
- error message if the fetch fails
- a `ListView` of remote entries otherwise

Each entry shows:

- folder/file/symlink icon
- name
- basic size/directory subtitle
- tap behavior for navigation or preview
- a trailing menu for preview, rename, download, and delete

### 17.5 File preview

The preview dialog uses `_FilePreview`.

Behavior:

- if the bytes look like PNG or JPEG, show an interactive image viewer
- otherwise decode as text and show it in a scrollable selectable monospace block

This is intentionally a preview, not an editor.

### 17.6 Important limitations

- directory listing is flat within the current path only
- delete is not recursive for non-empty directories
- downloads use the app documents directory directly
- uploads currently rely on `file_picker` returning in-memory bytes
- no remote permission editor exists yet

## 18. Snippets screen

The Snippets screen is `_SnippetsPage`.

Responsibilities:

- list saved snippets
- create and edit snippets
- delete snippets
- prompt for placeholder values
- run the rendered command in the active native session

### 18.1 Placeholder flow

If a snippet has placeholders:

1. the UI prompts the user for values
2. `SnippetInterpolator.render(...)` substitutes `{{placeholder}}` tokens
3. the workspace controller sends the rendered text to the active session
4. the repository updates `lastUsedAt`

### 18.2 Working directory hint

The model supports `workingDirectoryHint`, but the current runtime does not automatically `cd` before running a snippet. Right now it is stored metadata and future UX context.

## 19. Settings screen

The Settings screen is `_SettingsPage`.

Responsibilities:

- theme selection
- split session preference toggle
- saved key management
- known-hosts inspection and deletion

### 19.1 Appearance settings

The screen exposes:

- theme mode via `SegmentedButton`
- split session enable/disable via `SwitchListTile`

Important current limitation:

- these preferences are in memory only
- they reset on app relaunch

If you want persisted settings, this is a natural next extension area.

### 19.2 Saved keys area

The Saved Keys section:

- lists all `CredentialRef` entries of kind `privateKey`
- computes usage counts by scanning profiles
- can add a new key
- can copy the key ID
- can copy the stored public key
- can delete an unused key

Deletion is disabled while a key is still referenced by one or more server profiles.

### 19.3 Known Hosts area

Shows every trusted host fingerprint from the local store and lets the user delete entries.

Deleting a known host means the next connection will prompt again on first trust.

## 20. Saved key editor

The saved key modal is `lib/features/saved_key_editor_sheet.dart`.

It is intentionally narrow in responsibility: collect key material, validate it with `SshKeyService`, and return `SavedKeyMaterial`.

### 20.1 Actions

The modal supports:

- manual import of private key and public key
- `Generate Ed25519`
- `Derive Public Key`
- optional passphrase
- optional biometric requirement

### 20.2 Return contract

On success, the sheet pops with `SavedKeyMaterial`.

The Settings page then persists:

- metadata to the repository
- secrets to secure storage

## 21. Host trust UX

The concrete UI delegate for host trust is `_MaterialHostTrustDelegate` in `home_shell.dart`.

It implements `HostTrustDelegate` and shows dialogs for:

- unknown host approval
- changed host key approval

Why it matters:

- the SSH engine itself is UI-agnostic
- the app can change the host trust UX later without rewriting the connection logic

This is a good example of a clean service/UI boundary.

## 22. Test suite

The current tests cover both logic and a small amount of UI behavior.

### 22.1 `test/core/server_profile_validator_test.dart`

Covers:

- browser URL requirements for managed browser modes
- acceptance of a valid direct profile

### 22.2 `test/core/snippet_interpolator_test.dart`

Covers placeholder substitution behavior.

### 22.3 `test/data/app_repository_test.dart`

Covers:

- jump route ordering
- port forward persistence
- profile lookup ordering by requested IDs
- known-host update semantics
- saved key retention when deleting profiles

### 22.4 `test/services/ssh_key_service_test.dart`

Covers:

- Ed25519 key generation and re-import
- public/private key mismatch rejection

### 22.5 `test/home_shell_smoke_test.dart`

Provides a shell-level UI regression check, including the compact layout behavior that previously broke the Files page.

### 22.6 Test philosophy

The current suite is strongest around:

- pure helpers
- repository behavior
- key handling

It is lighter around:

- real SSH integration
- SFTP flows against a live server
- iOS platform behavior

Those are good areas for future expansion.

## 23. iOS platform details

The app is currently Apple-first, so the iOS project deserves special attention.

### 23.1 Deployment target

The project currently targets:

- `iOS 17+`

### 23.2 Entitlements

Runner entitlement files exist for debug/profile and release builds.

This is especially relevant for:

- secure storage
- simulator/device parity while testing credential flows

### 23.3 Simulator guidance

For day-to-day development:

- use `flutter run`
- or use Xcode

Do not rely on unsigned manual simulator installs to validate secure storage behavior.

## 24. Common extension recipes

This section is the practical part of the guide: where to make changes when you add features.

### 24.1 Add a new server-profile field

You usually need to touch:

1. `lib/data/app_database.dart`
2. generated Drift code via `build_runner`
3. `lib/data/repositories.dart`
4. `lib/features/server_editor_sheet.dart`
5. optionally validators/tests

Checklist:

- add the table column
- bump `schemaVersion` and add migration logic if needed
- map the field in `getProfiles()`
- persist the field in `saveProfile()`
- expose it in the editor UI
- validate it if required
- add or update tests

### 24.2 Add a new auth method

You usually need to touch:

1. `AuthMethod` enum in `repositories.dart`
2. server editor access section
3. `ConnectionEngine._connectClient()`
4. any validator rules
5. tests

Be especially careful that:

- the UI and runtime both understand the new method
- secure storage uses the right fields
- the editor does not allow impossible combinations

### 24.3 Add a new network mode

You usually need to touch:

1. `NetworkMode` enum
2. `ServerProfile.usesBrowserFallback` if behavior changes
3. server editor network mode choices
4. validation for browser URL/preflight requirements
5. any explanatory text in the UI
6. tests

Decide early whether the new mode is:

- a native SSH transport hint
- or a true browser-fallback mode

That decision changes the whole runtime path.

### 24.4 Persist app preferences

Right now, theme mode and split session preference are in-memory only.

To persist them cleanly:

1. introduce a small persistence layer, likely `SharedPreferences` or a Drift table
2. hydrate defaults inside `AppPreferencesController.build()`
3. persist writes in `setThemeMode()` and `setSplitSessions()`
4. add tests around startup hydration

### 24.5 Auto-start saved port forwards

The data model already supports this. The main missing work is runtime activation.

Likely implementation path:

1. add a runtime representation of active forwards to `ConnectedSession`
2. during native session launch, inspect `profile.portForwards`
3. start only those with `autoStart == true`
4. expose lifecycle/visibility in the Sessions UI
5. add cleanup on `close()`

### 24.6 Add remote text editing

The Files layer is already close to supporting it.

You would likely need:

1. a safe text/binary distinction
2. a remote read/write editor UI
3. optimistic or explicit save controls
4. encoding and large-file handling decisions
5. tests for round-trip SFTP writes

### 24.7 Split `home_shell.dart`

If the app grows further, a safe refactor would be:

- keep `HomeShell` in place
- move `_ServersPage`, `_SessionsPage`, `_FilesPage`, `_SnippetsPage`, `_SettingsPage` into separate files
- keep shared widgets such as `_PageHeader`, `_Badge`, `_EmptyState` in a common UI module

This is mostly an organization refactor and should not change behavior.

## 25. Known limitations and technical debt

This section is intentionally candid. These are not necessarily bugs, but they are places a future developer should understand before extending the code.

### 25.1 App preferences are not persisted

Theme mode and split-session preference reset between launches.

### 25.2 Port forwards are modeled more deeply than they are executed

The project stores port-forward definitions but does not yet expose a full forward runtime manager in the UI/session layer.

### 25.3 Snippet working-directory hints are metadata only

They are not automatically applied before command execution.

### 25.4 Keyboard-interactive auth is simple

All prompts are answered with the same stored secret. Multi-question custom prompt handling does not exist yet.

### 25.5 Files UI is functional but intentionally basic

No recursive delete, no permission editor, no inline text editing, no rich preview classification beyond simple image detection.

### 25.6 There is no backend or sync

That is intentional for v1, but it means:

- no cross-device key/profile sync
- no shared teams/workspaces
- no remote telemetry or crash-reporting pipeline in the current code

### 25.7 Provider-managed access is hybrid by design

The app does not attempt to fully replace:

- `cloudflared`
- `WARP`
- `Tailscale`
- provider certificate issuance or console internals

The model is:

- native SSH when reachable over the active network path
- browser handoff when the provider flow is browser-managed

## 26. Suggested onboarding order for new developers

If you are new to the project, read and inspect files in this order:

1. `README.md`
2. `lib/app/providers.dart`
3. `lib/data/repositories.dart`
4. `lib/services/connection_engine.dart`
5. `lib/services/workspace_controller.dart`
6. `lib/features/home_shell.dart`
7. `lib/features/server_editor_sheet.dart`
8. `lib/features/saved_key_editor_sheet.dart`
9. `test/`

That order mirrors the real architecture:

- app composition
- data model
- connection runtime
- session state
- UI
- feature editors
- tests

## 27. Day-to-day commands

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Analyze:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Regenerate Drift code after schema changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 28. Final mental model

If you need one short summary of how the codebase is arranged, use this:

- `AppRepository` owns persistent metadata
- `SecureStorageService` owns secrets
- `ConnectionEngine` owns transport/session setup
- `WorkspaceController` owns live tab/session state
- `HomeShell` owns top-level UX composition

Everything else is mostly a helper, a modal editor, or a view over one of those layers.

That mental model will keep you oriented even as the app grows.
