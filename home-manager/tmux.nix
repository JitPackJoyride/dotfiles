{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    aggressiveResize = true;
    terminal = "xterm-256color";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.extrakto
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    extraConfig = ''
      # split panes using | and -, make sure they open in the same path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      unbind '"'
      unbind %

      # open new windows in the current path
      bind c new-window -c "#{pane_current_path}"

      unbind p
      bind p previous-window

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # allow focus events to get through to applications running in tmux
      set -g focus-events on

      # shorten command delay
      set -sg escape-time 1

      # don't rename windows automatically
      set-option -g allow-rename off

      # DESIGN TWEAKS

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour yellow

      # copy mode
      setw -g mode-style 'fg=black bg=red bold'

      # panes
      set -g pane-border-style 'fg=red'
      set -g pane-active-border-style 'fg=yellow'

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=red'

      set -g status-left ""
      set -g status-left-length 10

      set -g status-right-style 'fg=black bg=blue'
      set -g status-right 'NY:#(TZ="America/New_York" date +"%%b-%%d %%H:%%M")|LD:#(TZ="Europe/London" date +"%%b-%%d %%H:%%M")|HK:#(TZ="Asia/Hong_Kong" date +"%%b-%%d %%H:%%M")'
      set -g status-right-length 100

      setw -g window-status-current-style 'fg=black bg=red'
      setw -g window-status-current-format ' #I #W #F '

      setw -g window-status-style 'fg=red bg=black'
      setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

      setw -g window-status-bell-style 'fg=yellow bg=red bold'

      # messages
      set -g message-style 'fg=yellow bg=red bold'
    '';
  };
}
