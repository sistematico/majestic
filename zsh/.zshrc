zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename '/home/lucas/.zshrc'

#################
## History     ##
#################
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000

#################
## Opt         ##
#################
setopt autocd extendedglob notify

#################
## Autoload    ##
#################
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

#################
## Aliases     ##
#################
# Core Aliases
alias ls='ls --color=auto --group-directories-first'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -pv'

# Main Aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

#################
## Functions   ##
#################
if [[ -f ~/.zsh_functions ]]; then
    source ~/.zsh_functions
fi

#################
## Sources     ##
#################
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

#################
## Keybindings ##
#################
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# Ctrl+Arrows
#key[Control-Left]="${terminfo[kLFT5]}"
#key[Control-Right]="${terminfo[kRIT5]}"
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Ctrl+Arrows
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Alt+Backspace
#backward-kill-dir () {
#    local WORDCHARS=${WORDCHARS/\/}
#    zle backward-kill-word
#    zle -f kill
#}
#zle -N backward-kill-dir
#bindkey '^[^?' backward-kill-dir

my-backward-delete-word () {
  local WORDCHARS='~!#$%^&*(){}[]<>?+;'
  zle backward-delete-word
}
zle -N my-backward-delete-word
#bindkey    '\e^?' my-backward-delete-word
bindkey '^[^?' my-backward-delete-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

prompt_stmco_setup() {
  PROMPT='%F{yellow}[%B%F{green}%n%f@%F{magenta}%m%f %F{blue}%~%b%F{yellow}]%f:%# '
  RPROMPT='[%F{yellow}%?%f]'
}
prompt_themes+=( stmco )
prompt stmco

eval `dircolors $HOME/.dircolors`

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
