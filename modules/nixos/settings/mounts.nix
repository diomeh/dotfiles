{ pkgs, ... }:
{
  # ntfs partition
  environment.systemPackages = [
    pkgs.ntfs3g
  ];

  fileSystems."/mnt/ntfs" = {
    device = "/dev/disk/by-uuid/D6744E28744E0C25";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/30AC5CF1AC5CB358";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/21385dd3-c78c-4b37-9910-62669628312b";
    fsType = "ext4";
  };
}
