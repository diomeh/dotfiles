{ pkgs, ... }:
let
  loadTheme = themeName: (builtins.fromTOML (builtins.readFile ./themes/${themeName}.toml)).colors;
in
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
    colorSchemes = {
      "VSCode_Dark" = loadTheme "vscode-dark";
    };
  };
}
