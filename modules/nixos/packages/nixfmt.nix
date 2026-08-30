{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt # Official formatter for Nix code
    nixfmt-tree # Official Nix formatter zero-setup starter using treefmt
  ];
}
