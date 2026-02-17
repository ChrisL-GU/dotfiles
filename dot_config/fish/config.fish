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
set -gx PATH $PATH "$NPM_INSTALL/bin"

set -gx PATH $PATH "$HOME/.bin"

# Dotnet
set -gx PATH $PATH "$HOME/.dotnet/tools"


# Claude Code through Azure Foundry 
# https://devblogs.microsoft.com/all-things-azure/claude-code-microsoft-foundry-enterprise-ai-coding-agent-setup/
set -gx CLAUDE_CODE_USE_FOUNDRY 1

# Azure resource name (replace {resource} with your resource name)
set -gx ANTHROPIC_MODEL claude-haiku-4-5
set -gx ANTHROPIC_FOUNDRY_RESOURCE lopes-coding-resource
# Or provide the full base URL:
# export ANTHROPIC_FOUNDRY_BASE_URL=https://{resource}.services.ai.azure.com

# Optional: specify model deployment names, matching the deployment names in Foundry
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-5"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5"
#export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-5"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

zoxide init fish | source
starship init fish | source

# opencode
fish_add_path /home/lopes/.opencode/bin

# https://evanhahn.com/scripts-i-wrote-that-i-use-all-the-time/
# Translated to fish
function tempe
    set tmpdir (mktemp -d)
    cd $tmpdir
    chmod -R 0700 .

    if test (count $argv) -eq 1
        mkdir -p $argv[1]
        cd $argv[1]
        chmod -R 0700 .
    end
end

# Added by get-aspire-cli.sh
fish_add_path $HOME/.aspire/bin
