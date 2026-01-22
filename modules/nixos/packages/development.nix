{ pkgs, config, ... }:
let
  unstable = import <nixos-unstable> {
    # reuse the current configuration
    config = config.nixpkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    vscode-fhs # Visual Studio Code with FHS support
    gitkraken # GitKraken Git GUI
    glab # GitLab CLI
    # bruno # API testing tool
    # unstable.beekeeper-studio # SQL GUI
    dbeaver-bin # SQL GUI
    kdePackages.kate # Kate text editor
    # sublime4 # Sublime Text
    zenity # Tool to display dialogs from the commandline and shell scripts
    # unstable.jetbrains.webstorm # Web development IDE
    # unstable.jetbrains.rust-rover # Rust IDE
    # unstable.jetbrains.pycharm-professional # Python IDE
    unstable.jetbrains.phpstorm # PHP IDE
    # unstable.jetbrains.datagrip # Database IDE from JetBrains
    unstable.android-studio # Official IDE for Android (stable channel)
    starship # Cross-shell prompt
    nurl # Nixos URL fetcher generator
    nix-init # Nixos package generator
    slack # Desktop client for Slack
    unstable.devenv # Fast, Declarative, Reproducible, and Composable Developer Environments
    bat # Cat clone with syntax highlighting and Git integration
    # btop # Monitor of resources
    gh # GitHub CLI tool
    rustup # Rust toolchain installer
    nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine
    act # Run your GitHub Actions locally
    postman # API Development Environment
    claude-code # Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster
    opencode # Terminal-based AI agent
  ];

  # Set user as trusted user of nix store
  # To allow devenv to auto-manage cache
  nix.settings.trusted-users = [
    "root"
    "${config.users.default.username}"
  ];
}
