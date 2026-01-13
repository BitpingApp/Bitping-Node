# NixOS module for bitpingd
# Can be used standalone or via the flake
{ config, lib, pkgs, ... }:

let
  cfg = config.services.bitpingd;
in
{
  options.services.bitpingd = {
    enable = lib.mkEnableOption "Bitping network node daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitpingd or (throw "bitpingd package not found. Use the flake overlay or specify a package.");
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
      description = "Directory to store bitpingd data and credentials.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for bitpingd P2P traffic.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--log-level" "debug" ];
      description = "Extra command line arguments to pass to bitpingd.";
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
      documentation = [ "https://github.com/BitpingApp/Bitping-Node" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/bitpingd ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "10s";

        # Security hardening
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        LockPersonality = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "@network-io" ];
        ReadWritePaths = [ cfg.dataDir ];

        # Network capabilities for raw sockets (required for ping functionality)
        AmbientCapabilities = [ "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_RAW" ];
      };

      environment = {
        HOME = cfg.dataDir;
      };
    };

    # Open firewall if requested
    networking.firewall = lib.mkIf cfg.openFirewall {
      # Add specific ports if known - bitpingd uses libp2p which typically
      # uses dynamic ports, but you may need to configure specific ones
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
