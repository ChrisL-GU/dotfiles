# Add $HOME/.local/bin and $HOME/bin to PATH if they're not already present
if not contains $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH
end

if not contains $HOME/bin $PATH
    set -gx PATH $HOME/bin $PATH
end

set -x EDITOR "nvim"
set -x VISUAL "nvim"

set -x NPM_INSTALL "/home/clopes/.npm-global"
set -gx PATH $PATH $NPM_INSTALL

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

zoxide init fish | source
starship init fish | source
