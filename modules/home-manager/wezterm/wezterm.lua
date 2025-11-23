-- wezterm is autoimported by home-manager
-- see: ~/.config/wezterm/wezterm.lua

local config = wezterm.config_builder()

-- Theme
config.color_scheme = "VSCode_Dark"

-- Font
config.font = wezterm.font_with_fallback({"GeistMono Nerd Font"})
config.font_size = 11

-- Cursor
config.default_cursor_style = "BlinkingBar"

-- Scrollback
config.scrollback_lines = 3500

-- Hide mouse cursor when typing
config.hide_mouse_cursor_when_typing = true

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.tab_bar_at_bottom = false -- top in kitty → false in wezterm
config.show_tab_index_in_tab_bar = false

-- Ligatures (disable)
config.harfbuzz_features = {"calt=0", "liga=0", "clig=0"}

-- Keybindings
config.keys = {{
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane) ~= ''
        if (not sel or sel == '') then
            window:perform_action(wezterm.action.SendKey {
                key = 'c',
                mods = 'CTRL'
            }, pane)
        else
            window:perform_action(wezterm.action.CopyTo 'ClipboardAndPrimarySelection', pane)
            window:perform_action(wezterm.action.ClearSelection, pane)
        end
    end)
}, -- copy to clipboard if selection exists or send ctrl+c to terminal
{
    key = 'v',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom 'Clipboard'
}, -- paste from clipboard
{
    key = 'v',
    mods = 'SHIFT|CTRL',
    action = wezterm.action_callback(function(window, pane)
        window:perform_action(wezterm.action.SendKey {
            key = 'v',
            mods = 'CTRL'
        }, pane)
    end)
}, -- send ctrl+v to terminal
{
    key = "N",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnWindow
}, -- new window
{
    key = "T",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain")
}, -- new tab
{
    key = "L",
    mods = "CTRL",
    action = wezterm.action.ClearScrollback("ScrollbackOnly")
}} -- clear scrollback

-- Scrollbar
config.enable_scroll_bar = true

-- Other
config.check_for_updates = false

return config
