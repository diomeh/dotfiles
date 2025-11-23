{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    # Add Nvidia beta kernel module to the initrd
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_beta ];
    initrd.kernelModules = [ "nvidia" ];

    # Preserve video memory after suspend/resume cycles to avoid graphical corruption
    # TODO: is not clear if this actually works, see https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  # Nvidia CUDA toolkit
  # FIXME: should be moved to a separate module, requires a lot of dependencies, see https://nixos.wiki/wiki/CUDA
  # environment.systemPackages = with pkgs; [
  #   linuxPackages.nvidia_x11
  #   cudaPackages.cudatoolkit
  # ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # Enable NVIDIA Optimus PRIME sync
    # Better GPU performance at the cost of battery
    prime = {
      # Set PRIME Sync on by default
      sync.enable = true;

      # Make sure to use the correct Bus ID values for your system!
      # Run `lspci | grep VGA` to find the correct Bus ID values
      # TODO: move values to config file and read from there
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
