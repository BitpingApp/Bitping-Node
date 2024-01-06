# Bitping Node (Public Beta)

## 🌟 Features
- **Auto-updates**: No need to manually check and install updates. The Bitping Node will download an update, check the signature and then auto install itself, meaning maintenance of your node is hands off.
- **New P2P network**: The new Bitping node utilises our new custom, P2P network built on top of the LibP2P framework.
- **Two versions available**:
  - **Bitping Desktop**: A user-friendly graphical interface for your desktop or laptop.
  - **bitpingd (for CLI)**: A robust and clear command-line interface for servers.
- **CalVer Versioning**: The versioning system follows the Calendar Versioning format (YY.M.DD-buildnumber).
- **Lower resource usage**: Compared to the old node, the new Bitpingd Node is more efficient and consumes fewer resources.
- **Clearer CLI flags**: `bitpingd` now has a more organized and understandable set of CLI flags. Check them out using `bitpingd --help`.
- **Service installation**: Easily install `bitpingd` as a service with the commands `bitpingd service install && bitpingd service start`. Compatibility includes Launchd on Mac and Systemd, initd, and openrc on Linux.

> 🚫 **Important**:
> It's not recommended to run both `bitpingd` and Bitping Desktop on the same machine as it may flag your nodes as spam in the network.
> Do not run multiple `bitpingd` or Bitping Desktop instances on the same machine when they are pointing to the same credentials directory (`~/.bitpingd`, `~/.bitping` or Docker volume)

## Installation

### Bitping Desktop
- **MacOS 11.0+**:
  1. Download the DMG from the [GitHub releases page](https://github.com/BitpingApp/Bitping-Node/releases).
  2. Open Bitping Desktop from your Applications folder

- **Windows 10+**:
  1. Download the MSI from the [GitHub releases page](https://github.com/BitpingApp/Bitping-Node/releases).
  2. Follow the installation steps.
  3. After installation, go to your start menu and click Bitping Desktop

### bitpingd (CLI version)
- For **MacOS or Linux**, simply run:
  ```bash
  curl https://bitping.com/install.sh | bash
  ```
  - To run the node with a display: 
    ```bash
    bitpingd
    ```
  - To run the node in the background:
      - ```bash 
        bitpingd service install && bitpingd service start
        ```
      - This command will keep your node running in the background when you log out
        ```bash
        sudo loginctl enable-linger $(whoami)
        ```
  - If you are setting up bitpingd as root, you will need to run:
      - ```bash 
           bitpingd service install --system && bitpingd service start --system
        ```
- For Bitpingd on **Docker**:
  - To run the container in interactive mode:
    - ```bash 
        docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd bitping/bitpingd:latest
      ```
  - To run the container and pass email and password via CLI instead of an interactive session run:  
    - ```bash 
        docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd --entrypoint /app/bitpingd bitping/bitpingd:latest login --email "YOUR_BITPING_EMAIL" --password "YOUR_BITPING_PASSWORD"
      ```
    - ```bash 
        docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd bitping/bitpingd:latest
      ```

## Support

If you encounter any issues or need further guidance, please:
- Open an issue on [this GitHub repo](https://github.com/BitpingApp/Bitping-Node/issues).
- Join the [Bitping Support chat on Telegram](https://t.me/bitping).

Thank you for being part of our beta program! Your feedback is invaluable.
