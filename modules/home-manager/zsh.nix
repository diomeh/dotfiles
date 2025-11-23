{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza # Replacemnt for ls
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true; # Save timestamp into the history file.
      ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
      save = 10000; # Number of history lines to save in the history file.
      share = true; # Share history between zsh sessions.
      size = 10000; # Number of history lines to save in the history list.
    };

    plugins = [ ];

    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --git --icons"; # Display icons and git status

      l = "ls -lahbX"; # [l]ong format, [a]ll files, s[h]ow header, [b]inary size prefix, dereference symlinks
      ll = "ls -l"; # [l]ong format
      la = "ls -a"; # [a]ll files
      lt = "ls --tree"; # Tree format
      ldir = "l -D"; # [D]irectories only
      lfil = "l -f"; # [f]iles only
      lf = "l | fzf"; # [f]uzzy search
      lg = "l | grep --recursive --ignore-case"; # list and find [r]ecursively and case [i]nsensitive

      protontricks = "flatpak run com.github.Matoking.protontricks";

      # HACK: allow for dsu's paste to take priority over the system's paste
      # Ideally, we should be able to solve this at the dsu derivation level
      # but that's a rabbit hole I don't want to go down right now
      # See: https://discourse.nixos.org/t/are-there-rules-to-order-of-entries-in-path/9471/3
      # See: https://github.com/Diomeh/dsu
      paste = "/run/current-system/sw/bin/paste";
    };

    # Extra commands that should be added to {file}.zshrc.
    initContent = ''
      # ctrl + backspace to delete word to the left of cursor
      bindkey '^H' backward-kill-word

      # ctrl + delete to delete word to the right of cursor
      bindkey '^[[3;5~' kill-word

      # Disable user@system in shell prompt (needed for om-my-zsh agnoster theme)
      # prompt_context(){}

      # Automatically launch Steam in offload mode
      # See: https://nixos.wiki/wiki/Nvidia#Using_Steam_in_Offload_Mode
      export XDG_DATA_HOME="$HOME/.local/share"

      # JetBrains IDEs
      PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

      # Force export PKG_CONFIG_PATH so that rust IDEs can find openssl
      # Theoretically this should work with environment.sessionVariables but it doesn't
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"

      # Add ~/.local/bin to PATH
      PATH="$PATH:$HOME/.local/bin"

      # Enable starship prompt
      eval "$(starship init zsh)"

      # Alias functions

      # Open kitty tab in specified directory
      kcd () {
          local path="''${1:-.}"
          ${pkgs.kitty}/bin/kitty @ launch --type tab --cwd "$path"
      }
    '';

    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
        "docker"
        "web-search"
        "direnv"
        "fzf"
        "colored-man-pages"
        "colorize"
        "composer"
        "docker-compose"
        "docker"
        "history"
        "man"
        "rust"
        "sudo"
      ];
      extraConfig = ''
        # Add your custom oh-my-zsh configuration here
      '';
    };
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
}
