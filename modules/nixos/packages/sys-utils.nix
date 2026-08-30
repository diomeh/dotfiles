{ pkgs, config, ... }:
let
  nixos-2411 = import <nixos-24.11> {
    # reuse the current configuration
    config = config.nixpkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    git # Git version control
    gcc # GNU Compiler Collection
    vim # Vi IMproved
    wget # A network utility to retrieve files from the Web
    curl # A command line tool and library for transferring data with URLs
    pciutils # PCI bus related utilities
    nixos-2411.neofetch # A command-line system information tool
    tlrc # TLDR man pages written in Rust
    lshw # A small tool to provide detailed information on the hardware configuration of the machine
    lsof # A utility to list open files
    bc # GNU software calculator
    kdePackages.filelight # Disk usage analyzer
    xdg-utils # Workaround for xdg-open, see: https://github.com/NixOS/nixpkgs/issues/145354
    silver-searcher # A code searching tool similar to ack, with a focus on speed
    translate-shell # Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium
    fzf # General-purpose command-line fuzzy finder.
    gparted # Gnome partition manager
  ];
}
