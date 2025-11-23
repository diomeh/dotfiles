{
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO: move to config file
  enablePrimeOffload = true;
  intelBusId = "PCI:0:2:0";
  nvidiaBusId = "PCI:1:0:0";
in
rec {
  boot = {
    # Add Nvidia beta kernel module to the initrd
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_beta ];
    initrd.kernelModules = [ "nvidia" ];

    # Preserve video memory after suspend/resume cycles to avoid graphical corruption
    # See https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  # Nvidia CUDA toolkit
  # FIXME: should be moved to a separate module, requires a lot of dependencies, see https://nixos.wiki/wiki/CUDA
  # environment.systemPackages = with pkgs; [
  #   linuxPackages.nvidia_x11
  #   cudaPackages.cudatoolkit
  # ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # For offloading, `modesetting` is needed additionally,
  # otherwise the X-server will be running permanently on nvidia,
  # thus keeping the GPU always on (see `nvidia-smi`).
  services.xserver.videoDrivers =
    if enablePrimeOffload then
      [
        "modesetting" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
        "nvidia"
      ]
    else
      # Load nvidia driver for Xorg and Wayland
      [ "nvidia" ];

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
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # For currently supported cards, see: https://www.nvidia.com/en-us/drivers/unix/
    # For legacy cards, see: https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      # Make sure to use the correct Bus ID values for your system!
      # Run `lspci | grep VGA` to find the correct Bus ID values
      intelBusId = intelBusId;
      nvidiaBusId = nvidiaBusId;
    }
    // (
      if enablePrimeOffload then
        {
          # Enable NVIDIA Optimus PRIME offloading
          # Saves battery by using the integrated GPU by default and only
          # switching to the NVIDIA GPU when needed
          # Requires several manual steps to use the NVIDIA GPU for specific applications
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        }
      else
        {
          # Enable NVIDIA Optimus PRIME sync
          # Better GPU performance at the cost of battery
          sync.enable = true;
        }
    );
  };

  # Add the gpu-run script to the system packages for easy use of PRIME offloading
  # This will be available as the `gpu-run` command for all users
  environment.systemPackages = lib.mkIf (enablePrimeOffload) [
    (pkgs.stdenv.mkDerivation {
      name = "gpu-run";
      src = ../scripts/gpu-run.sh;
      phases = [ "installPhase" ];
      installPhase = ''
        install -Dm755 "$src" "$out/bin/gpu-run"
      '';
    })
  ];
}
