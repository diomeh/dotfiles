{ pkgs, config, ... }:
{
  environment.sessionVariables = {
    # For proton GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${config.users.default.username}/.steam/root/compatibilitytools.d";
  };

  environment.variables = {
    # Prevent error `Nvidia DRM kernel driver ‘nvidia-drm’ in use. NVK requires nouveau` when running wine
    VK_DRIVER_FILES = /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json;
  };

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable # wine 64-bit
    winetricks
    protonup-ng # Proton GE

    # For ModOrganizer 2

    # TODO: enable once issue 304 is fixed
    # See: https://github.com/Matoking/protontricks/issues/304
    # protontricks # Wrapper for running Winetricks commands for Proton-enabled games

    # For now, install beta through pipx
    # See: https://github.com/Matoking/protontricks/issues/304#issuecomment-2220599470
    python312Packages.pip # The PyPA recommended tool for installing Python packages
    python312Packages.pipx # Install and run Python applications in isolated environments
    # INFO: DO NOT FORGET TO UNINSTALL protontricks with pipx before removing it
    # $ pipx uninstall protontricks
  ];
}
