{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.etlegacyServer;
in
{
  options.services.etlegacyServer = {
    enable = lib.mkEnableOption "";

    package = lib.mkPackageOption pkgs "etlegacy" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "etlegacy";
      description = "";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "etlegacy";
      description = "";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/etlegacy-server";
      description = ''
      '';
    };

    openFirewall = lib.mkEnableOption "";

    settings = {
      serverName = lib.mkOption {
        type = lib.types.str;
        default = "ET: Legacy";
        description = "";
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 27960;
        description = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.services.etlegacy-server = {
      description = "ET Legacy server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
      }
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ serverPort ];
    };
  };
}
