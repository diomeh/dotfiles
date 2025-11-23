{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    heroic # Heroic Games Launcher
    bottles # Bottles Wine Manager
    lutris # Game Manager
    steam-run # Run any binary from CLI. Not related to Valve's Steam
    vesktop # Discord 3rd party chat client, see https://github.com/Vencord/Vesktop
    zerotierone # VPN for LAN emulation
    dolphin-emu # Gamecube and Wii emulator
  ];
}
