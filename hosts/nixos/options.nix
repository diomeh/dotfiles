{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  # Helper function to define user configuration
  mkUserOption = {
    isNormalUser = true; # Is this a human user?
    username = "diomeh";
    description = "diomeh";
    groups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    home = "/home/diomeh";
    pkgs = with pkgs; [ ];
  };
in
{
  options = {
    users.default = mkOption {
      type = types.attrs;
      default = mkUserOption;
      description = "Default user configuration.";
    };

    rclone = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable rclone service.";
      };

      conf = mkOption {
        type = types.path;
        default = "${config.users.default.home}/.config/rclone/rclone.conf";
        description = "Path to rclone configuration file.";
      };

      gdrive = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Google Drive integration.";
        };

        mount = mkOption {
          type = types.path;
          default = "/rmt/gdrive";
          description = "Mount point for Google Drive.";
        };
      };

      mega = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Mega integration.";
        };

        mount = mkOption {
          type = types.path;
          default = "/rmt/mega";
          description = "Mount point for Mega.";
        };
      };
    };
  };
}
