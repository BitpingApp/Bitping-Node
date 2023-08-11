# Bitping Node (Public Beta)

## 🌟 Features
- **Auto-updates**: No need to manually check and install updates. The Bitping Node will download an update, check the signature and then auto install itself, meaning maintenance of your node is hands off.
- **New P2P network**: The new Bitping node utilises our new custom, P2P network built on top of the LibP2P framework.
- **Two versions available**:
  - **Bitping Desktop**: A user-friendly graphical interface for your desktop or laptop.
  - **bitpingd (for CLI)**: A robust and clear command-line interface for servers.
- **CalVer Versioning**: The versioning system follows the Calendar Versioning format (YY.M.DD-buildnumber).
- **Lower resource usage**: Compared to the old node, the new Bitping Node is more efficient and consumes fewer resources.
- **Clearer CLI flags**: `bitpingd` now has a more organized and understandable set of CLI flags. Check them out using `bitpingd --help`.
- **Service installation**: Easily install `bitpingd` as a service with the commands `bitpingd service install && bitpingd service start`. Compatibility includes Launchd on Mac and Systemd, initd, and openrc on Linux.

> 🚫 **Important**: It's not recommended to run both `bitpingd` and Bitping Desktop on the same machine as it may flag your nodes as spam in the network.

## Installation

### Bitping Desktop
- **MacOS**:
  1. Download the DMG from the [GitHub releases page](https://github.com/BitpingApp/Bitping-Node/releases).
  2. After installation, unquarantine with the command:
     ```bash
     xattr -d com.apple.quarantine /Applications/Bitping\ Desktop.app
     ```

- **Windows**:
  1. Download the MSI from the [GitHub releases page](https://github.com/BitpingApp/Bitping-Node/releases).
  2. Follow the installation steps.

- **Linux**:
  1. We recommend downloading the AppImage file from the [GitHub releases page](https://github.com/BitpingApp/Bitping-Node/releases).
  2. There's also a .deb file available, but it's not extensively tested, especially for auto-updates.

### bitpingd (CLI version)
- For **MacOS or Linux**, simply run:
  ```bash
  curl https://bitping.com/install.sh | bash
  ```
  - To run without a display: `bitpingd`
  - For visualizing Jobs performed, current balance, uptime, and more: `bitpingd run --display`

## Support

If you encounter any issues or need further guidance, please:
- Open an issue on [this GitHub repo](https://github.com/BitpingApp/Bitping-Node/issues).
- Join the [Bitping Support chat on Telegram](https://t.me/bitping).

Thank you for being part of our beta program! Your feedback is invaluable.
