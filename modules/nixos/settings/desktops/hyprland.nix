{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  use_nvidia_gpu = config.boot.kernelPackages == pkgs.linuxPackages.nvidia_x11;
in
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # nvidia specific session variables
  environment.sessionVariables = lib.mkIf use_nvidia_gpu {
    # WAYLAND_DISPLAY = ":1";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "hyprland";

    # Prevent invisible cursor
    WLR_NO_HARDWARE_CURSORS = "1";

    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    libnotify
    dunst # Notification daemon
    swww # Sway wallpaper
    kitty # Terminal emulator
    alacritty
    rofi-wayland # Application launcher
    networkmanagerapplet # Network manager applet
    grim # Screenshot tool
    slurp # Select tool
    wl-clipboard # Clipboard manager
  ];

  services.displayManager.sddm.wayland.enable = true;

  # Enable desktop portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = { };
}
