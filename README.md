# Bitping Node

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
> 
> Do not run multiple `bitpingd` or Bitping Desktop instances on the same machine when they are pointing to the same credentials directory (`~/.bitpingd`, `~/.bitping` or Docker volume)

## Recommendations

#### Passive Income while actively using your computer
Use Bitping Desktop on MacOS and Windows. 
Bitping Desktop does not explicitly run in the background while you are logged out of your computer.
The Idea of Bitping Desktop is to have you passively earn income while you're going about your daily activities on your computer/laptop.

#### Constant Passive Income 
Use Bitpingd on Linux.
Bitpingd is built to be run as a system daemon either via Systemd, Launchd or Docker. 
It will run in the background even while your user account is logged out. 

## Installation

Running a node with Bitping is easy, be sure to have an account created [here](https://app.bitping.com/register)

Then navigate to the node Install/Update page in the [Bitping Dashboard](https://app.bitping.com/update)

You can then follow the step by step instructions below dependent on your operating system and install method.

### Bitping Desktop

#### MacOS 11.0+ Desktop
  1. Navigate to the [Bitping Install page](https://app.bitping.com/update).
  2. Based on which chipset you have, choose either Intel or Apple Silicon and click the download button.
  3. Navigate to your Downloads folder in Finder and double click on the Bitping Desktop DMG
  4. Drag the Bitping Desktop icon to your Applications folder
  5. Open Bitping Desktop from your Applications folder

#### Windows 10+ Desktop
  1. Navigate to the [Bitping Install page](https://app.bitping.com/update).
  2. Click on the Download button for the Desktop application.
  3. Open your downloads folder and double click on the MSI and follow the installation steps.
  3. After installation, go to your start menu and click Bitping Desktop

### Bitpingd

#### Linux CLI
1. Install the bitpingd binary with the following script:
    ```bash
    curl https://bitping.com/install.sh | bash
    ```
2. Login to the Bitping network:
    ```bash
    bitpingd login
    ```
3. To run the node with a display: 
    ```bash
    bitpingd
    ```
4. If you are setting up the bitpingd service as **root/sudo**, you will need to run:
    ```bash 
    bitpingd service install --system && bitpingd service start --system
    ```
5. To run the node in the background as an unpriveliged user:
      - ```bash 
        bitpingd service install && bitpingd service start
        ```
      - This command will keep your node running in the background when you log out
        ```bash
        sudo loginctl enable-linger $(whoami)
        ```
        
#### MacOS CLI
1. Install the bitpingd binary with the following script:
    ```bash
    curl https://bitping.com/install.sh | bash
    ```
2. Login to the Bitping network:
    ```bash
    bitpingd login
    ```
3. To run the node with a display: 
    ```bash
    bitpingd
    ```
4. If you are setting up the bitpingd service as **root/sudo**, you will need to run:
    ```bash 
    bitpingd service install --system && bitpingd service start --system
    ```
5. To run the node in the background as an unpriveliged user:
      - ```bash 
        bitpingd service install && bitpingd service start
        ```

#### NixOS / Nix

This repository includes a Nix flake for declarative installation on NixOS and other Nix-enabled systems.

##### Quick Install (nix profile)
```bash
nix profile install github:BitpingApp/Bitping-Node
```

##### Run without installing
```bash
nix run github:BitpingApp/Bitping-Node
```

##### NixOS Module (flake-based configuration)

Add the flake to your `flake.nix` inputs:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bitping.url = "github:BitpingApp/Bitping-Node";
  };

  outputs = { self, nixpkgs, bitping, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        bitping.nixosModules.default
        {
          services.bitpingd.enable = true;
        }
      ];
    };
  };
}
```

##### Initial Login

Before enabling the service, you need to log in to create credentials:
```bash
# Run interactively to log in
nix run github:BitpingApp/Bitping-Node -- login

# Copy credentials to the service data directory
sudo mkdir -p /var/lib/bitpingd
sudo cp -r ~/.bitpingd/* /var/lib/bitpingd/
sudo chown -R bitpingd:bitpingd /var/lib/bitpingd
```

##### Module Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `services.bitpingd.enable` | bool | `false` | Enable the bitpingd service |
| `services.bitpingd.user` | string | `"bitpingd"` | User to run the service as |
| `services.bitpingd.group` | string | `"bitpingd"` | Group to run the service as |
| `services.bitpingd.dataDir` | path | `/var/lib/bitpingd` | Data directory for credentials |
| `services.bitpingd.extraArgs` | list | `[]` | Extra CLI arguments |

##### Updating the Flake

To get the latest version with updated hashes:
```bash
git clone https://github.com/BitpingApp/Bitping-Node
cd Bitping-Node
chmod +x update.sh
./update.sh
```

#### Docker
##### Option 1. To run the container in interactive mode: 
   ```bash
    docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd bitping/bitpingd:latest
   ```

##### Option 2. To run the container and pass email and password via CLI instead of an interactive session run:  
  1. Log in to your account with the following command:
       ```bash
       docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd --entrypoint /app/bitpingd bitping/bitpingd:latest login --email "YOUR_BITPING_EMAIL" --password "YOUR_BITPING_PASSWORD"
       ```
  2. Now start the bitping node!
       ```bash 
       docker run -it --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd bitping/bitpingd:latest
       ```

##### Option 3. Login with environment variables:  
   ```bash 
   docker run -it \
     -e BITPING_EMAIL='YOUR_BITPING_EMAIL' \
     -e BITPING_PASSWORD='YOUR_BITPING_PASSWORD' \
     -e BITPING_MFA='YOUR_BITPING_2FA_CODE' \
     --mount type=volume,source="bitpingd-volume",target=/root/.bitpingd bitping/bitpingd:latest
   ```

## Support

If you encounter any issues or need further guidance, please:
- Open an issue on [this GitHub repo](https://github.com/BitpingApp/Bitping-Node/issues).
- Join the [Bitping Support chat on Telegram](https://t.me/bitping).

Thank you for being part of our beta program! Your feedback is invaluable.
