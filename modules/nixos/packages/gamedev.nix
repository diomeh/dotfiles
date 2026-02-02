{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    godotPackages_4_6.godot # Game engine
    blender # 3D modeling and animation suite
    obs-studio # Free and open source software for video recording and live streaming
    aseprite # Pixel art tool (requires license)
  ];
}
