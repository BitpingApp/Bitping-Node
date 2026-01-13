{
  description = "Bitping Node - Decentralized network node for passive income";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      # Version information - update these when new releases are available
      # Check https://releases.bitping.com/bitpingd/update.json for latest
      version = "25.1.12-1";

      # Platform-specific download URLs and hashes
      # To update hashes, run: nix-prefetch-url <url>
      sources = {
        x86_64-linux = {
          url = "https://releases.bitping.com/bitpingd/bitpingd-linux-x86_64-${version}.tar.gz";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
        aarch64-linux = {
          url = "https://releases.bitping.com/bitpingd/bitpingd-linux-aarch64-${version}.tar.gz";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
        armv7l-linux = {
          url = "https://releases.bitping.com/bitpingd/bitpingd-linux-armv7-${version}.tar.gz";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
        x86_64-darwin = {
          url = "https://releases.bitping.com/bitpingd/bitpingd-darwin-x86_64-${version}.tar.gz";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
        aarch64-darwin = {
          url = "https://releases.bitping.com/bitpingd/bitpingd-darwin-aarch64-${version}.tar.gz";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
      };

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" "x86_64-darwin" "aarch64-darwin" ];

      mkBitpingd = system: pkgs:
        let
          source = sources.${system} or (throw "Unsupported system: ${system}");
          isLinux = pkgs.lib.hasSuffix "-linux" system;
        in
        pkgs.stdenv.mkDerivation {
          pname = "bitpingd";
          inherit version;

          src = pkgs.fetchurl {
            url = source.url;
            hash = source.hash;
          };

          sourceRoot = ".";

          nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

          buildInputs = with pkgs; pkgs.lib.optionals isLinux [
            stdenv.cc.cc.lib
            libcap
          ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp bitpingd $out/bin/bitpingd
            chmod +x $out/bin/bitpingd

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Bitping decentralized network node daemon";
            homepage = "https://bitping.com";
            license = licenses.unfree;
            platforms = supportedSystems;
            maintainers = [ ];
            mainProgram = "bitpingd";
          };
        };

    in
    {
      # NixOS module for running bitpingd as a service
      nixosModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.services.bitpingd;
        in
        {
          options.services.bitpingd = {
            enable = lib.mkEnableOption "Bitping network node daemon";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.system}.default;
              defaultText = lib.literalExpression "pkgs.bitpingd";
              description = "The bitpingd package to use.";
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "bitpingd";
              description = "User account under which bitpingd runs.";
            };

            group = lib.mkOption {
              type = lib.types.str;
              default = "bitpingd";
              description = "Group under which bitpingd runs.";
            };

            dataDir = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/bitpingd";
              description = "Directory to store bitpingd data.";
            };

            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to open the firewall for bitpingd P2P traffic.";
            };
          };

          config = lib.mkIf cfg.enable {
            users.users.${cfg.user} = {
              isSystemUser = true;
              group = cfg.group;
              home = cfg.dataDir;
              createHome = true;
              description = "Bitping daemon user";
            };

            users.groups.${cfg.group} = { };

            systemd.services.bitpingd = {
              description = "Bitping Network Node Daemon";
              wantedBy = [ "multi-user.target" ];
              after = [ "network-online.target" ];
              wants = [ "network-online.target" ];

              serviceConfig = {
                Type = "simple";
                User = cfg.user;
                Group = cfg.group;
                WorkingDirectory = cfg.dataDir;
                ExecStart = "${cfg.package}/bin/bitpingd";
                Restart = "on-failure";
                RestartSec = "10s";

                # Hardening
                NoNewPrivileges = true;
                ProtectSystem = "strict";
                ProtectHome = true;
                PrivateTmp = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectControlGroups = true;
                ReadWritePaths = [ cfg.dataDir ];

                # Network capabilities for raw sockets (ping)
                AmbientCapabilities = [ "CAP_NET_RAW" ];
                CapabilityBoundingSet = [ "CAP_NET_RAW" ];
              };

              environment = {
                HOME = cfg.dataDir;
              };
            };

            # Open firewall if requested
            networking.firewall = lib.mkIf cfg.openFirewall {
              allowedTCPPorts = [ ];
              allowedUDPPorts = [ ];
            };
          };
        };

      nixosModules.bitpingd = self.nixosModules.default;

    } // flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          bitpingd = mkBitpingd system pkgs;
          default = self.packages.${system}.bitpingd;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          exePath = "/bin/bitpingd";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.default ];
        };
      }
    );
}
