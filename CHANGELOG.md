# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] – 2025-05-13

### Added
- Comprehensive Alfred workflow documentation in README:
  - Project overview, setup instructions, search usage examples, configuration guide, and troubleshooting.
- Populated `info.plist` metadata:
  - `description` key set to “Search apps on the app store”
  - `readme` key filled with full usage guide and screenshots
  - `version` key set to “v1.0.0”
  - `webaddress` key pointing to https://github.com/philocalyst/alfred-app-store-search
- Corrected repository URLs in README and troubleshooting section to point to `philocalyst/alfred-app-store-search`

## [0.1.0] – 2025-05-13

### Added
- Optional hotkey trigger for App Store Search  
  • Introduces a new hotkey object (UID C38F8F2C-246F-4BDC-B431-90EEA564D209) in `info.plist` with its own connection, modifiers, UI position, and color settings  
- Workflow action script entrypoint  
  • Adds a dedicated script action (UID 61B1E226-9EEA-4705-9499-01914973279D) to run `mas open {query}`  

### Changed
- Variadic search keyword support  
  • Replaces the hard-coded keyword `"mas"` with `{var:KEYWORD}` in the workflow’s `<keyword>` field  
  • Adds a `userconfigurationconfig` entry for `KEYWORD` with default `mas`, placeholder text, and required/trim flags  

---

[Unreleased]: https://github.com/philocalyst/alfred-app-store-search/compare/v1.0.1...HEAD  
[1.0.1]: https://github.com/philocalyst/alfred-app-store-search/compare/v1.0.0...v1.0.1
[0.1.0]:    https://github.com/philocalyst/app-store-search/compare/v0.0.0...v0.1.0
