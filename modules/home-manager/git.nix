{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    lfs.enable = true; # Enable Git large file storage support

    # System dependent config file that may or may not exist
    includes = [ { path = "~/.gitconfig.local"; } ];

    settings = {
      user = {
        name = "David Urbina";
        email = "davidurbina.dev@gmail.com";
      };

      push.autoSetupRemote = true;

      pager = {
        branch = false;
      };
      init = {
        defaultBranch = "master";
      };
      credential = {
        helper = "store";
      };
      core = {
        pager = "less -FX";
      };
      safe = {
        directory = "/etc/nixos";
      };

      alias = {
        # Basic usage
        append = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
        publish = "!git push -u origin $(git current-branch)";

        co = "checkout";

        # Branch management
        current-branch = "!git rev-parse --abbrev-ref HEAD";
        master-branch = "!git rev-parse --abbrev-ref $(git remote)/HEAD";
        master-branch-local = "!git rev-parse --abbrev-ref $(git remote)/HEAD | sed 's/.*\\///'";
        prune-branches = "!git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == \"[gone]\" {sub(\"refs/heads/\", \"\", $1); print $1}'); do git branch -D $branch; done";
        pull-submodules = "!git submodule foreach 'git checkout $(git master-branch-local) && git pull || :'";

        cb = "current-branch";
        mb = "master-branch";
        mbl = "master-branch-local";
        pb = "prune-branches";
        ps = "pull-submodules";

        # Diff management
        diff-remote = "!git log --name-status --oneline $(git master-branch)..";
        diff-local = "!git log --name-status --oneline $(git master-branch-local)..";

        dr = "diff-remote";
        dl = "diff-local";

        # Log related
        graph = "log --graph --pretty=format:'%C(bold red)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
        history = "log --pretty=format:'%Cgreen%h%Creset %C(bold blue)<%an>%Creset - %s'";
        last = "log -1 HEAD";

        # Changes related
        current-changes = "diff --stat";
        last-changes = "diff --stat HEAD^ HEAD";

        cc = "current-changes";
        lc = "last-changes";

        # Config related
        list-config = "config --list --show-origin --show-scope | awk '{ print $1 \" -- \" $2 }' | sort | uniq";
        list-aliases = "config --show-scope --get-regexp ^alias\\.";

        llc = "list-config";
        lla = "list-aliases";
      };
    };

  };
}
