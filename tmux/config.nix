pkgs: {
  enable = true;
  package = pkgs.tmux;
  prefix = "C-a";
  keyMode = "vi";
  terminal = "tmux-256color";
  historyLimit = 40000;
  mouse = true;
  escapeTime = 0;
  aggressiveResize = true;
  # Start index of window/pane with 1, because of keyboard layout
  baseIndex = 1;

  extraConfig = builtins.readFile ./tmux.conf;

  plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator
    prefix-highlight
    online-status
    sidebar
    {
      plugin = catppuccin;
      extraConfig =
        builtins.readFile ./catppuccin.conf;
    }
    cpu
    battery
    copycat
    open

    {
      plugin = resurrect;
      extraConfig = ''
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-restore 'O'
      '';
    }
    {
      plugin = continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '60' # minutes
      '';
    }
  ];
}
