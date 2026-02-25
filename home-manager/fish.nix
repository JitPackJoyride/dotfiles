{
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellInit = ''
      # turn off the greeting
      set fish_greeting
      source ~/.orbstack/shell/init2.fish 2>/dev/null || :
      set -gx EDITOR vim
      fish_vi_key_bindings
      /run/current-system/sw/bin/mise activate fish | source
    '';
    shellAliases = {
      lg = "lazygit";
      y = "yazi";
      j = "z";
      mi = "mise run";
    };
    functions = {
      nix-darwin-rebuild = ''
        set CURRENT_DIR (pwd)
        echo "🚨 Current directory: $CURRENT_DIR"
        z platform
        echo "🚨 In platform directory: $(pwd)"
        git switch build/update-nix
        git pull --rebase
        z dotfiles
        echo "🚨 In dotfiles directory: $(pwd)"
        git add .
        darwin-rebuild switch --flake ~/dotfiles/.#simple
        z platform
        echo "🚨 Back in platform directory: $(pwd)"
        git checkout -
        cd $CURRENT_DIR
        echo "🚨 Back in current directory: $(pwd)"
      '';
      code = ''
        set location "$PWD/$argv"
        open -n -b "com.microsoft.VSCode" --args $location
      '';
      docker-rm-rf = ''
        docker ps -qa | xargs -r docker rm -f
      '';
      fish-rm-path = ''
        if set -l index (contains -i $argv[1] $PATH)
            set --erase --universal fish_user_paths[$index]
            echo "Updated PATH: $PATH"
        else
            echo "$argv[1] not found in PATH: $PATH"
        end
      '';
      gpull = ''
        git pull $argv
      '';
      gpush = ''
        git push $argv
      '';
      gs = ''
        git status $argv
      '';
      ni = ''
        npm ci --ignore-scripts
      '';
      uvi = ''
        uv venv && source .venv/bin/activate.fish && uv sync
      '';
    };
  };
}
