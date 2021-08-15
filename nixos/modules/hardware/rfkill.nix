{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.rfkill;
in
{
  options.hardware.rfkill = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Install rfkill udev rules.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.rfkill_udev ];
    users.groups.rfkill = { };
  };
}
