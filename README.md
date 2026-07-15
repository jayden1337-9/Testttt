# Nova Browser
A modern, fast, and modular web browser written in Flutter, designed for Android. Features a custom virtual filesystem (NovaFS), internal protocol routing, and a built-in file manager.

## Setup & Build
1. Ensure you have Flutter installed (`>=3.0.0`).
2. Clone this repository.
3. Run `flutter pub get`.
4. Run `flutter build apk --release` to build an APK.

## Features (v1.0)
- Multi-tab browsing & Incognito mode
- NovaFS Virtual Filesystem with built-in File Manager
- Download Manager (Pause/Resume/Cancel)
- Bookmarks & History (Saved to NovaFS)
- Custom Protocols (nova://, browser://, about:)
- Reader Mode, Desktop Mode, Find in Page
- Security Suite (HTTPS checks, SSL warnings, JS/Popup toggles)
- Built-in PDF Viewer & External App Routing

## Architecture
- lib/core/: Core utilities, constants, and protocol routing
- lib/browser/: Browser-specific logic
- lib/filesystem/: NovaFS virtual filesystem
- lib/ui/: Flutter UI (pages, widgets)
- lib/models/: Data models
- lib/services/: Business logic
