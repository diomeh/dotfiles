{ pkgs, options, ... }:
{
  # Enable nix-ld
  # This module adds missing dynamic libraries for unpackaged programs
  programs.nix-ld = {
    enable = true;
    libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        # Add missing dynamic libraries for unpackaged
        # programs here, NOT in environment.systemPackages
      ]);
    # FIXME: This fails to add libraries wirh error `error: expected a set but found a list`
    # Add steam-run DLL's
    # ++ (pkgs.steam-run.fhsenv.args.multiPkgs pkgs);
  };
}
