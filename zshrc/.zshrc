# Use Ctrl+Z as interrupt instead of Ctrl+C
# This must be done before Powerlevel10k instant prompt
stty intr ^Z

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function command_exists()
{
    which "$@" > /dev/null 2>&1
}

# Location for storing plugins
ZGEN_DIR="$HOME/.zgenom"
ZSHELL_DIR="$HOME/.zsh"

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP=$ZSH_CACHE_DIR/.zcompdump
HISTFILE="$ZSH_CACHE_DIR/.zsh_history"

# Disable Oh-My-ZSH's internal updating.
DISABLE_AUTO_UPDATE=true

ZSH_AUTOSUGGEST_STRATEGY=(completion)

export EDITOR='code'
export VISUAL=${EDITOR}
export TZ='America/Los_Angeles'

# https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-pagination.html
export AWS_PAGER=""

# https://docs.docker.com/develop/develop-images/build_enhancements/
export DOCKER_BUILDKIT=1

# Load plugin manager
source "${HOME}/zgenom/zgenom.zsh"

if ! zgenom saved; then
  # To update the saved shell init, run `zgenom reset`
  echo "Creating a zgenom save"

  zgenom ohmyzsh

  # Adds 'acs' alias that lists aliases grouped by plugin
  zgenom ohmyzsh plugins/aliases

  # Use 'acp' command to change profiles
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aws
  zgenom ohmyzsh plugins/aws

  # SSH keys are subkeys of GPG
  # https://opensource.com/article/19/4/gpg-subkeys-ssh
  zgenom ohmyzsh plugins/gpg-agent

  # Fuzzy history search
  # https://github.com/junegunn/fzf
  zgenom ohmyzsh plugins/fzf

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions

  # zgenom load MichaelAquilina/zsh-autoswitch-virtualenv

  # Theme
  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom load chrissicool/zsh-256color

  # Ctrl + Shift + Arrow to select by word
  zgenom load jirutka/zsh-shift-select

  zgenom load "$ZSHELL_DIR/keybindings.zsh"
  zgenom load "$ZSHELL_DIR/functions.zsh"
  zgenom load "$ZSHELL_DIR/aliases.zsh"
  zgenom load "$ZSHELL_DIR/autosuggestions-workaround.zsh"

  # save all to init script
  zgenom save

  # Compile your zsh files
  # zgenom compile "$HOME/.zshrc"
fi

# Make python3.9 the default if it is avaiable
if command_exists python3.9; then
  alias python='python3.9'
fi

if command_exists register-python-argcomplete; then
  # pipx completions https://pypa.github.io/pipx/
  eval "$(register-python-argcomplete pipx)"
fi

if command_exists pnpm; then
  # tabtab source for packages
  # uninstall by removing these lines
  [[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
fi

# Dedupe $PATH using a ZSH builtin
# https://til.hashrocket.com/posts/7evpdebn7g-remove-duplicates-in-zsh-path
typeset -aU path

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
