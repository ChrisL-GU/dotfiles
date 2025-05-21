# Add $HOME/.local/bin and $HOME/bin to PATH if they're not already present
if not contains $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH
end

if not contains $HOME/bin $PATH
    set -gx PATH $HOME/bin $PATH
end

# F: Automatically quit if content fits in one screen
# R: Show raw control characters (e.g., color codes)
# X: Don’t clear the screen on exit
export LESS=FRX

set -x EDITOR "nvim"
set -x VISUAL "nvim"

set -x NPM_INSTALL "$HOME/.npm-global"
set -gx PATH $PATH $NPM_INSTALL

set -gx PATH $PATH "$HOME/.bin"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

zoxide init fish | source
starship init fish | source
