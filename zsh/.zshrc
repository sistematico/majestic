zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename '/home/lucas/.zshrc'

###############
## History   ##
###############
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000

###############
## Opt       ##
###############
setopt autocd extendedglob notify

autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash

# Binds
bindkey -e

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Ctrl+Arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Alt+Backspace
autoload -Uz select-word-style
select-word-style bash

###############
## Aliases   ##
###############
# Core Aliases
alias ls='ls --color=auto --group-directories-first'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -pv'

# Main Aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

###############
## Functions ##
###############
if [[ -f ~/.zsh_functions ]]; then
    source ~/.zsh_functions
fi

# Sources
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

autoload -Uz promptinit && promptinit

prompt_stmco_setup() {
  PROMPT='%F{yellow}[%B%F{green}%n%f@%F{magenta}%m%f %F{blue}%~%b%F{yellow}]%f:%# '
  RPROMPT='[%F{yellow}%?%f]'
}
prompt_themes+=( stmco )
prompt stmco

eval `dircolors $HOME/.dircolors`
