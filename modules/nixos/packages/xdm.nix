{ config, pkgs, ... }:

let
  # Remember to update the hash when the version changes
  # nurl https://github.com/Diomeh/nix-xdm <VERSION>
  xdm = pkgs.fetchFromGitHub {
    owner = "Diomeh";
    repo = "nix-xdm";
    rev = "0.0.4";
    hash = "sha256-d2F8lOBXP4wMLnuaQ4/mDUeKQeCr57diqCn5DO9vGAA=";
  };
in
{
  environment.systemPackages = [
    # Custom XDM (Xtreme Download Manager) derivation
    (pkgs.callPackage "${xdm}/derivation.nix" { inherit pkgs; })
  ];
}
