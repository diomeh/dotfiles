{ pkgs, ... }:
let
  # Starship is a shell agnostic prompt
  # See: https://starship.rs/
  # For more information on configuring starship, see: https://starship.rs/config/
  # For a reference on icons, see: https://www.nerdfonts.com/cheat-sheet

  # This configuration is based off Gruvbox Rainbow preset, see: https://starship.rs/presets/gruvbox-rainbow/
  # Because of the way the prompt is set up, all icons used for all modules should be monochrome
  # This facilitates foreground and background color changes; refer to nerdfonts cheat sheet for monochrome icons

  # NOTE: it is advised to pair every icon with a blank space, otherwise the prompt will look cluttered
  # e.g. " " instead of ""

  lang_symbols = {
    "rust" = " ";
    "nodejs" = " ";
    "php" = " ";
    "python" = " ";
  };

  lang_style = "bg:color_blue";
  lang_format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';

  # Function to build lang configs
  mkLangMap =
    lang_symbols: lang_style: lang_format:
    builtins.mapAttrs (lang: symbol: {
      symbol = symbol;
      style = lang_style;
      format = lang_format;
    }) lang_symbols;

  languages = "$" + (builtins.concatStringsSep "$" (builtins.attrNames lang_symbols));

  prompt_segments = [
    # left side of prompt

    # system
    "[█](color_orange)$os$username$sudo"

    # directory
    "[](bg:color_yellow fg:color_orange)$directory"

    # git
    "[](fg:color_yellow bg:color_aqua)$git_branch$git_commit$git_status$git_state[](fg:color_aqua)"

    # separate left and right side
    "$fill"

    # right side of prompt
    # dev languages
    "[](fg:color_blue)${languages}"

    # tools
    "[](fg:color_bg3 bg:color_blue)$docker_context$conda$direnv$nix_shell"

    # time
    "[](fg:color_bg1 bg:color_bg3)$time$status"

    # command line
    "[█](bold fg:color_bg1)$line_break$character"
  ];
in
{
  programs.starship = {
    enable = true;

    # Configuration written to ~/.config/starship.toml
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      # Concat all prompt segments into a single string
      format = builtins.concatStringsSep "" prompt_segments;
      continuation_prompt = "[](bold fg:color_green)";

      line_break.disabled = false;

      fill = {
        disabled = false;
        symbol = " ";
        style = "";
      };

      palette = "diomir";
      palettes.diomir = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      os = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";

        symbols = {
          Windows = "󰍲 ";
          Ubuntu = "󰕈 ";
          SUSE = " ";
          Raspbian = "󰐿 ";
          Mint = "󰣭 ";
          Macos = "󰀵 ";
          Manjaro = " ";
          Linux = " 󰌽";
          Gentoo = "󰣨 ";
          Fedora = "󰣛 ";
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = "󰣇 ";
          Artix = "󰣇 ";
          EndeavourOS = " ";
          CentOS = " ";
          Debian = "󰣚 ";
          Redhat = "󱄛 ";
          RedHatEnterprise = "󱄛 ";
          NixOS = "";
        };
      };

      sudo = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";
        format = "[ $symbol ]($style)";
        symbol = " ";
      };

      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = ''[ $user ]($style)'';
      };

      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)[$read_only]($read_only_style)";
        truncation_length = 5;
        truncation_symbol = "…/";
        read_only = " ";
        read_only_style = "fg:color_red bg:color_yellow";

        substitutions = {
          "home" = " ";
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "/mnt/drive" = "󱛟 ";
          "/mnt/drive/dev" = " ";
        };
      };

      git_branch = {
        symbol = " ";
        style = "bg:color_aqua";
        format = ''[[ $symbol$branch(:$remote_branch) ](fg:color_fg0 bg:color_aqua)]($style)'';
      };

      git_commit = {
        style = "bg:color_aqua";
        format = ''[[ $hash@$tag ](fg:color_fg0 bg:color_aqua)]($style)'';
        only_detached = true;
      };

      git_state = {
        style = "bg:color_aqua";
        format = ''[[ $state($progress_current/$progress_total) ](fg:color_fg0 bg:color_aqua)]($style)'';
      };

      git_status = {
        ignore_submodules = true;
        style = "bg:color_aqua";
        format = ''[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'';
        conflicted = "󰵉 ";
        ahead = " ";
        behind = " ";
        diverged = " ";
        up_to_date = "";
        untracked = " ";
        stashed = "󰆼 ";
        modified = "󰦒 ";
        staged = " ";
        renamed = " ";
        deleted = " ";
        typechanged = "";
      };

      docker_context = {
        symbol = " ";
        style = "bg:color_blue";
        format = ''[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'';
      };

      conda = {
        style = "bg:color_blue";
        format = ''[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'';
      };

      direnv = {
        disabled = false;
        style = "bg:color_blue";
        format = ''[[ $symbol($loaded) ](fg:#83a598 bg:color_bg3)]($style)'';
        loaded_msg = "";
        unloaded_msg = "✘";
      };

      nix_shell = {
        style = "bg:color_blue";
        format = ''[[ $symbol$state ](fg:#83a598 bg:color_bg3)]($style)'';
        symbol = " ";
        impure_msg = " ";
        pure_msg = "";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_bg1";
        format = ''[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'';
      };

      status = {
        disabled = false;
        style = "bg:color_bg1";
        format = ''[[ $symbol$status ](fg:color_fg0 bg:color_bg1)]($style)'';
        symbol = "✘";
        not_executable_symbol = " ";
        not_found_symbol = " ";
        sigint_symbol = " ";
        signal_symbol = "󱐋";
        map_symbol = true;
        pipestatus = true;
        pipestatus_format = ''\[$pipestatus\] => [$symbol$common_meaning$signal_name$maybe_int](fg:color_fg0 bg:color_bg1)]($style)'';
      };

      character = {
        disabled = false;
        success_symbol = ''[ ](bold fg:color_green)'';
        error_symbol = ''[✘](bold bg:color_red)[ ](bold fg:color_red)'';
        vimcmd_symbol = ''[ ](bold fg:color_green)'';
        vimcmd_replace_one_symbol = ''[ ](bold fg:color_purple)'';
        vimcmd_replace_symbol = ''[ ](bold fg:color_purple)'';
        vimcmd_visual_symbol = ''[ ](bold fg:color_yellow)'';
      };
    }
    # Add custom language configurations
    # e.g lang = {symbol, style, format}
    // mkLangMap lang_symbols lang_style lang_format;
  };
}
