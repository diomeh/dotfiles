{ pkgs, ... }:
{
  # Generate fontconfig file
  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;

  # Nerd Fonts
  fonts.packages = with pkgs; [
    corefonts
    vistafonts
    nerd-fonts.symbols-only
    nerd-fonts.geist-mono
  ];

  fonts.fontconfig.defaultFonts.monospace = [
    "GeistMono"
    "Symbols Nerd Font"
    "DejaVu Sans Mono"
  ];
}
