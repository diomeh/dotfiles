{ pkgs, ... }:
{
  # Kitty terminal emulator
  # See:
  # - https://github.com/nix-community/home-manager/blob/master/modules/programs/kitty.nix
  # - https://sw.kovidgoyal.net/kitty/conf.html
  programs.kitty = {
    enable = true;

    # INFO: Apparently kitty doesn't support scrollbar?? Why? May be a dealbreaker.
    # See: https://github.com/kovidgoyal/kitty/issues/2502#issuecomment-606996263

    # https://github.com/kovidgoyal/kitty-themes
    # https://sw.kovidgoyal.net/kitty/kittens/themes/
    themeFile = "VSCode_Dark";

    shellIntegration.enableZshIntegration = true;
    font = {
      package = pkgs.nerd-fonts.geist-mono;
      size = 11;
      name = "Geist";
    };
    settings = {
      disable_ligatures = "always";
      cursor_shape = "beam";
      scrollback_pager_history_size = 1024;
      scrollback_fill_enlarged_window = "yes";
      mouse_hide_wait = 0;
      show_hyperlink_targets = "yes";
      underline_hyperlinks = "always";
      paste_actions = "quote-urls-at-prompt,confirm,replace-dangerous-control-codes,replace-newline,filter";
      strip_trailing_spaces = "always";
      confirm_os_window_close = 0;
      notify_on_cmd_finish = "unfocused";
      wayland_enable_ime = "no";
      tab_bar_edge = "top";
      tab_bar_min_tabs = 1;
      tab_bar_style = "slant";
      tab_activity_symbol = "•";
      allow_remote_control = "yes";
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+n" = "new_os_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";

      # Keybinding sucks absolute ass
      # either it clears scrollback and I'm forced to press enter
      # or just clear the screen pushing everything to scrollback which is same as ctrl+l
      "ctrl+shift+k" = "clear_terminal scrollback active";

      # Fix ctrl+l so that it pushes content on screen to scrollback
      "ctrl+l" = "clear_terminal to_cursor_scroll active";
    };
    environment = { };
    extraConfig = ''
      # Add your custom kitty configuration here
    '';
  };
}
