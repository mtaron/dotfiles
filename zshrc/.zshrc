# Use Ctrl+Z as interrupt instead of Ctrl+C
# This must be done before Powerlevel10k instant prompt
stty intr ^Z

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Location for storing plugins
ZGEN_DIR="$HOME/.zgenom"

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Disable Oh-My-ZSH's internal updating.
DISABLE_AUTO_UPDATE=true

ZSH_AUTOSUGGEST_STRATEGY=(completion)

export EDITOR='code'
export VISUAL=${EDITOR}
export TZ='America/Los_Angeles'

# Load plugin manager
source "${HOME}/zgenom/zgenom.zsh"

if ! zgenom saved; then
  echo "Creating a zgenom save"

  zgenom ohmyzsh

  zgenom ohmyzsh plugins/sudo
  zgenom ohmyzsh plugins/aliases
  zgenom ohmyzsh plugins/aws
  zgenom ohmyzsh plugins/command-not-found

  # https://github.com/junegunn/fzf
  zgenom ohmyzsh plugins/fzf

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions

  zgenom load lukechilds/zsh-nvm

  # Theme
  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom load chrissicool/zsh-256color

  # save all to init script
  zgenom save

  # Compile your zsh files
  # zgenom compile "$HOME/.zshrc"
fi

# Source: https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-483938570
# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste accept-line)

source "$HOME/.zsh/aliases.zsh"
source "$HOME/.zsh/keybindings.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
