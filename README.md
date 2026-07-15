# Nova Browser

A modern, modular browser written in Flutter, designed for Android. Features a custom virtual filesystem (NovaFS) and internal protocol routing.

## Setup
1. Ensure you have Flutter installed.
2. Clone this repository.
3. Run `flutter pub get`.
4. Connect an Android device or emulator.
5. Run `flutter run`.

## Architecture
- `lib/core/`: Core utilities, constants, and protocol routing.
- `lib/browser/`: Browser-specific logic (tabs, webview management).
- `lib/filesystem/`: NovaFS virtual filesystem implementation.
- `lib/downloads/`: Download manager logic.
- `lib/network/`: Network interceptors and custom handlers.
- `lib/ui/`: Flutter UI (pages, widgets).
- `lib/models/`: Data models.
- `lib/services/`: Business logic services.
- `lib/utils/`: Helper functions.

## Roadmap to v1.0
- [x] Project initialization and architecture setup
- [x] NovaFS Interface & Protocol Routing Definitions
- [ ] Webview integration & Tab Management
- [ ] NovaFS Local Storage Implementation
- [ ] Internal Pages (`about:newtab`, `nova://settings`)
- [ ] Download Manager
- [ ] Security & Sandboxing features
