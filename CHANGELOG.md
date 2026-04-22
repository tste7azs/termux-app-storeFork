# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to semantic versioning.


## [Unreleased]

### Added
- New menu `termux-build init` for auto create and build package
- New file termux-build-init.sh in directory tools for auto create and build package
- Package `auxscan` v1.0.0 - Vulnerability Scanner to automate certain tasks, improve
- Package `clickjacking-tester` v1.0.0 - A python script designed to check if the website if vulnerable of clickjacking and create a poc
- Package `cmseek` v1.1.3 - CMS Detection and Exploitation suite - Scan WordPress, Joomla, Drupal and over 180 other CMSs
- Package `cmsmap` v1.0.0 - CMSmap is a python open source CMS scanner that automates the process of detecting security flaws of the most popular CMSs. 
- Package `gemail-hack` v1.0.0 - python script for Hack gmail account brute force
- Package `ghosttrack` v1.0.0 - Useful tool to track location or mobile number
- Package `goblinwordgenerator` v1.0.0 - Python wordlist generator 
- Package `hammer` v1.0.0 - Ddos attack tool for termux
- Package `hash-buster` v1.0.0 - hash-buster — auto-packaged by termux-build-init
- Package `ht-wps-breaker` v1.0.0 - HT-WPS Breaker (High Touch WPS Breaker)
- Package `hunner` v1.0.0 - Hacking framework
- Package `instareporter` v1.0.0 - Instagram Mass Reporting Tool
- Package `ip-tracker` v1.0.0 - Track anyones IP just opening a link!
- Package `ipgeolocation` v2.0.4 - Retrieve IP Geolocation information
- Package `lazymux` v1.0.0 - termux tool installer
- Package `termux-ai` v1.0.0 - Interactive AI tool for Termux with 10+ providers and 50+ image models ✨
- Package `userfinder` v1.0.0 - userfinder — auto-packaged by termux-build-init
- Package `termux-sync` v0.1.0 - OpenSource Backup and restore your entire Termux environment across devices.
- Package `lalin` v1.0.0 - this script automatically install any package for pentest with uptodate tools , and lazy command for run the tools like lazynmap , install another and update to new #actually for lazy people hahaha #and Lalin is remake the lazykali with fixed bugs , added new features and uptodate tools . Its compatible with the latest release of Kali (Rolling)
- Package `myserver` v1.0.0 - myserver — auto-packaged by termux-build-init
- Package `parsero` v1.0.0 - Parsero | Robots.txt audit tool
- Package `red-hawk` v1.0.0 - All in one tool for Information Gathering, Vulnerability Scanning and Crawling. A must have tool for all penetration testers
- Package `sublist3r` v1.1 - Fast subdomains enumeration tool for penetration testers
- Package `termuxalpine` v1.0.0 - Use TermuxAlpine.sh calling to install Alpine Linux in Termux on Android. This setup script will attempt to set Alpine Linux up in your Termux environment.
- Package `the-eye` v1.0.0 - Simple security surveillance script for linux distributions.

### Changed
- Package `bashxt` v2.2 - Updated metadata
- Package `cybertuz` v1.0.1 - Updated metadata
- Package `impulse` v1.0.0 - Updated metadata
- Package `pymaker` v1.0.0 - Updated metadata
- Package `fd` v10.4.2 - Updated metadata
- Package `ani-cli` v4.11 - Updated metadata

### Update
- Package `aura` v0.8.2 → v0.10.0
- Package `fd` v10.3.0 → v10.4.2
- Package `ani-cli` v4.10 → v4.11
- Package `uv` v0.10.4 → v0.11.7
- Package `sigit` v2.0-pre → v2.0

---

## [v0.2.4] - 2026-04-07
### Update
- Change log message format in CLI
- Repack and download build-package for installer package
- Fixed bug not found `build-package` before install package
- Fixed bug installer in TUI and CLI
- Fixed fetch bug version
- Auto update core to source with `termux-app-store update`
- Update formating docs
- Update source version to `__init__.py` or `pyproject.toml`
- Update support installer manual (git clone) or auto (pip install)
- Fixed crash launcher and intaller packages

---

## [v0.2.3] - 2026-04-06
### Update
- Update system core `termux-app-store update`
- Support installer with `pip install termux-app-store`
- `main.py` `termux_app_store.py` `termux_app_store_cli.py` resolve app
- Package `tdoc` v1.0.5 → v1.0.6
- Package `basic` v1.0.0 → v1.0.2

### Added
- Package `basic` v1.0.0 - Simulator Terminal learning basic command for beginner
- Package `cybertuz` v1.0.1 - Comprehensive Educational Learning Platform for Termux

### Changed
- Package `basic` v1.2.0 - Updated metadata

### Remove
- All ilegal packages

---

## [v0.1.7] - 2026-03-02
### Added
- Added an `uninstall button` to the text-based user interface (TUI)
- Package `bashxt` v2.2 - basic command, code color, shortcut keyboar, etc information
- Package `aura` v0.8.2 - Adaptive Unified Runtime Assistant
- Package `tx` v1.0.0 - Advance Terminal Editor Ultimate
- Package `aircrack-ng` v1.7 - aircrack-ng for termux package
- Package `ani-cli` v4.10 - A cli tool to browse and play anime
- Package `fd` v10.3.0 - A simple, fast and user-friendly alternative to find
- Package `lux` v0.24.1 - Fast and simple video download library and CLI tool written in Go
- Package `maskphish` v2.0 - URL Making Technology to the world for the very tool for Phishing.
- Package `zx` v8.8.5 - A tool for writing better scripts
- Package `bower` v1.8.12 - A package manager for the web
- Package `infoooze` v1.1.9 - A OSINT tool which helps you to quickly find information effectively.
- Package `pnpm` v10.30.1 - Fast, disk space efficient package manager
- Package `sigit` v2.0-pre - SIGIT - Simple Information Gathering Toolkit
- Package `tuifimanager` v5.2.6 - A terminal-based TUI file manager
- Package `uv` v0.10.4 - An extremely fast Python package and project manager, written in Rust.
- Package `zorabuilder` v1.0.0 - Builder python standalone ELF

### Changed
- Package `impulse` v1.0.0 - Updated metadata
- Package `iptrack` v1.0.0 - Updated metadata
- Package `pymaker` v1.0.0 - Updated metadata
- Package `zora` v1.0.0 - Updated metadata
- Package `zoracrypter` v1.0.0 - Updated metadata
- Package `zoravuln` v1.0.0 - Updated metadata
- Package `ghostrack` v1.0.0 - Updated metadata
- Package `tdoc` v1.0.5 - Updated metadata

### Update
- Package `zora` v1.0.0 → v1.2.0

---

## [v0.1.6] - 2026-02-18
### Added
- index.json for based
- update_index workflows
- package_manager for index
- build for index

### Update
- `termux-app-store` new interface (CLI)
- `termux-app-store` feature index based
- System `update` and `upgrade`
- Installer interface
- Uninstaller interface
- Auto CLI workflows for PR (Pull Request)
- Colors `termux-build`
- Auto install / update / uninstall with `tasctl`

### Fixed
- Fixed build-package for installing package
- Fixed renovate workflows
- Fixed update log workflows
- Fixed PR Checker workflows
- Fixed Lint Cheker workflows

---

## [v0.1.4] - 2026-02-13
### Added
- Package `impulse` v1.0.0
- Package `zoracrypter` v1.0.0
- Package `zora` v1.0.0
- Package `ghostrack` v1.0.0
- Package `iptrack` v1.0.0
- `termux-build create` for easy create packages and build.sh
- `termux-build lint <package>` for check validation
- `termux-build doctor` for check error

### Update
- New interface (TUI and CLI)
  - command:
    - `termux-app-store` (Open interface)
    - `termux-app-store help`
    - `termuc-app-store list`
    - `termux-app-store show <package>`
    - `termux-app-store update`
    - `termux-app-store upgrade` (Upgrade all outdated installed)
    - `termux-app-store upgrade <package>`
    - `termux-app-store version`
  - short command
    - `termux-app-store -h` = help
    - `termux-app-store -v` = version
    - `termux-app-store i or -i <package> = install package
    - `termux-app-store -l or -L` = list package
- Auto CLI workflows for PR (Pull Request)
- Colors `termux-build`
- Auto install / update / uninstall with `tasctl`

### Fixed
- Fixed build-package for installing package
- Fixed error renovate workflows
- Fixed update log workflows
- Fixed PR Checker workflows
- Fixed Lint Checker workflows

---

## [v0.1.2] - 2026-02-10
### Added
- Package `pymaker` v1.0.0
- Package `baxter` v1.2.4
- termux-build for check lint, check-pr, and etc
- Package browser with search and live preview
- tasctl for install, uninstall, update termux-app-store
- Auto-detection of system architecture
- file uninstall.sh
- Portable path resolver (works via symlink, binary, or any directory)
- Self-healing package path detection
- Support architecture aarch64, arm, x86_64, i686
- Progress bar and live build log panel
- Status badges: INSTALLED
- Status information: maintainer

### Fixed
- List panel not updating preview on ENTER
- ProgressBar API misuse causing runtime crash
- Failure when running outside project root directory
- Crash when directory is missing or relocated
- Fast render

### Changed
- Improved package scanning logic
- Safer subprocess handling for build output
- More robust UI refresh behavior during installation

---

## [v0.1.0] - 2026-02-02
### Added
- Package `webshake` v1.0.2
- Package `termstyle` v1.0.0
- Package `tdoc` v1.0.5
- Package `pmcli` v0.1.0
- Package `encrypt` v1.1
- Textual-based TUI application for Termux
- Package browser with search and live preview
- Install / Update workflow using `build-package.sh`
- Auto-detection of system architecture
- Portable path resolver (works via symlink, binary, or any directory)
- Self-healing package path detection
- Inline CSS embedded in Python (no external CSS dependency)
- Progress bar and live build log panel
- Status badges: `NEW`, `INSTALLED`, `UPDATE`

### Fixed
- List panel not updating preview on ENTER
- ProgressBar API misuse causing runtime crash
- Failure when running outside project root directory
- Crash when `packages/` directory is missing or relocated

### Changed
- Improved package scanning logic
- Safer subprocess handling for build output
- More robust UI refresh behavior during installation

### Planned
- Binary distribution via GitHub Releases
- Automatic dependency validation for unsupported Termux packages
- UI badge for `UNSUPPORTED` packages
- Pre-build validation for `build.sh`

---

## [v0.0.1] - 2026-01-xx
### Initial
- Internal prototype
- Local-only execution
