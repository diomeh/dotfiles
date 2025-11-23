{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  rclone = config.rclone;
  gdrive = config.rclone.gdrive;
  mega = config.rclone.mega;
in
{
  environment.systemPackages = mkIf (rclone.enable) [
    pkgs.rclone # Rclone is a command line program to manage files on cloud storage
  ];

  # # Define mount points to cloud storage (ideally, all under /rmt)
  fileSystems."${gdrive.mount}" = mkIf (rclone.enable && gdrive.enable) {
    device = "gdrive:/";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=${rclone.conf}"
    ];
  };

  fileSystems."${mega.mount}" = mkIf (rclone.enable && mega.enable) {
    device = "mega:/";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=${rclone.conf}"
    ];
  };
}
