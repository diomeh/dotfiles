{ pkgs, ... }:
{
  # ntfs partition
  environment.systemPackages = [
    pkgs.ntfs3g
  ];

  fileSystems."/mnt/ntfs" =
    { device = "/dev/disk/by-uuid/D6744E28744E0C25";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000"];
    };

  fileSystems."/mnt/windows" =
    { device = "/dev/disk/by-uuid/30AC5CF1AC5CB358";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000"];
    };
}
