{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xfel;
in
{
  options.programs.xfel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Installs xfel and configures udev rules for the on-chip
	bootloader. Grants access to users in the "users"
        group.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.xfel ];
    environment.systemPackages = [ pkgs.xfel ];
    users.groups.users = { };
  };
}
