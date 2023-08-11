# Bitping Node (Public Beta)

Welcome to the public beta of the Bitping Node! We're excited to introduce our latest node implementation, which offers a slew of features optimized for performance and ease-of-use. Dive in and explore what's new.

## Features

- **Written in Rust**: Rust ensures a fast, secure, and highly concurrent experience.
- **Auto-Updates**: No manual intervention needed to get the latest features and improvements.
- **New LibP2P based Network**: Our most advanced and efficient networking solution.
- **Two Versions to Choose From**:
  - **Bitping Desktop**: A GUI-based application for those who prefer visual interfaces.
  - **bitpingd**: For the CLI enthusiasts. Comes with clear and extensive CLI flags.
- **Versioning System**: We follow CalVer naming convention - YY.M.DD-buildnumber.
- **Optimized Performance**: Uses fewer resources than the old node.
- **Service Installation**: `bitpingd` can be installed as a service, making it compatible with a wide range of system managers including Launchd on Mac and Systemd, initd, and openrc on Linux.

## Installation Guide

### Bitping Desktop

**MacOS**:
1. Download the DMG file from the GitHub releases page.
2. Before opening the app, you must unquarantine it. Run:
   ```
   xattr -d com.apple.quarantine /Applications/Bitping\ Desktop.app
   ```

**Windows**:
1. Download the MSI from the GitHub releases page.
2. Follow the installation steps.

**Linux**:
1. We recommend using the AppImage file from the releases page for a smoother experience.
2. Alternatively, a .deb file is available, but it might not support auto-updates as it has not been extensively tested.

### bitpingd (CLI Version)

**MacOS & Linux**:
1. To install, run the following command:
   ```
   curl https://releases.bitping.com/bitpingd/install.sh | sh
   ```
2. To start the service, simply run:
   ```
   bitpingd
   ```

## Support and Feedback

Experiencing issues or have suggestions? We'd love to hear from you.

- **Report Issues**: Please open an issue on this GitHub repository.
- **Live Support**: Join our [Bitping Support chat on Telegram](https://t.me/bitping).

Thank you for being part of our public beta. Your feedback will shape the future of Bitping Node.
