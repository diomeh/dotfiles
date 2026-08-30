{ pkgs, config, ... }:
let
  unstable = import <nixos-unstable> {
    # reuse the current configuration
    config = config.nixpkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    unstable.godot # Game engine
    blender # 3D modeling and animation suite
    obs-studio # Free and open source software for video recording and live streaming
    aseprite # Pixel art tool (requires license)
  ];
}
