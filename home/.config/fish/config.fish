# mise — activate early so mise-managed tools (starship, etc.) are on PATH
if status is-interactive
    ~/.local/bin/mise activate fish | source
else
    ~/.local/bin/mise activate fish --shims | source
end

set -gx EDITOR vi

if status is-interactive
    set fish_greeting          # no greeting
    fish_vi_key_bindings       # vi mode at the prompt
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
end

# 1Password shell plugins
source ~/.config/op/plugins.sh

# orbstack
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# pnpm global bin
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME/bin
