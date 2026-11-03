# Changelog

All notable changes to Pigeon Engine are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- **Major** versions can need changes to your configuration or other resources. Read the **Upgrade notes**.
- **Minor** versions add features without breaking existing setups.
- **Patch** versions fix bugs only.

## [Unreleased]

## [1.0.0] - 2026-11-03

First release.

### Highlights

- Start and stop the engine with one key
- Engines keep running when you get out
- Engines stay off until you start them
- Damaged engines struggle, then won't start at all
- Wheels stay turned when you park

### Added

- Starting and stopping the engine with one key (M by default, which players can change in GTA's key bindings) or `/engine`, for the driver, with a short turn of the key.
- Engines that are off staying off when someone gets in to drive, until they start them; or GTA's own starting on entering.
- Engines that keep running when the driver gets out: always, only when they hold the exit key, or never.
- Damaged engines that take longer to start, sometimes don't catch, and below a set health won't start at all.
- The front wheels staying turned the way they were when the driver got out.
- `Config.CanStart`, for vehicle keys resources to decide who can start what.
- `ToggleEngine`, `IsEngineRunning` and `SetEngine` client exports.
- Every message in `locales/`.
- Update checker from the Pigeon Studios version registry.

[Unreleased]: https://github.com/pigeon-studios-uk/pigeon-engine/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/pigeon-studios-uk/pigeon-engine/releases/tag/v1.0.0
