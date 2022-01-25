####################
# Helper functions #
####################
# These functions are open used for the rc files and will be removed at the end
source_if_exists() {
  if [ -s $1 ]; then
    source $1
  fi
}

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) :;;
    *) PATH="$1:$PATH"
  esac
}

append_path() {
  case ":$PATH:" in
    *":$1:"*) :;;
    *) PATH="$PATH:$1"
  esac
}

#################
# Generic Setup #
#################

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -x /usr/bin/dircolors ]; then
  alias ls="ls --color=auto"
  alias grep="grep --color=auto"
fi

if [ -d "$HOME/.local/bin" ]; then
  prepend_path "$HOME/.local/bin"
fi

if [ -d "$HOME/bin" ]; then
  prepend_path "$HOME/bin"
fi

if [ -d "/snap/bin" ]; then
  append_path "/snap/bin"
fi

# Command not found fixes
if [[ -x /usr/lib/command-not-found ]] ; then
  if (( ! ${+functions[command_not_found_handler]} )) ; then
    function command_not_found_handler {
      [[ -x /usr/lib/command-not-found ]] || return 1
      /usr/lib/command-not-found  -- ${1+"$1"} && :
    }
  fi
fi

# Autocomplete will highlight on tab and allow arrows
autoload -U compinit && compinit
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"      # menu complete shows ls colors
zstyle ':completion:*' menu select                        # menu completion

# Show completion menu immediately and do not auto select first completion entry
setopt automenu
setopt nomenucomplete

# Will allow for directory completion like scripts/run by doing sc<TAB>/r<TAB>
setopt autocd

# After TAB selecting the entry, pressing enter once will immediately execute
# the command
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
# use the vi navigation keys in menu completion
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history

setopt complete_in_word # Complete even at a middle of a word
setopt always_to_end # Move cursor to the end of a word after completion from middle

# Hyphen insensivie and case insentive matches
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Ignore comments in shell
setopt interactivecomments

# Automatically pushd
setopt auto_pushd
setopt pushd_ignore_dups

setopt no_beep

# History configurations
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
alias history="fc -il 1"
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Prompt will substitute even when single quoted.
# This avoid the prompt being subtituted only once during boot
setopt promptsubst

# Use the most concise way to represent the directory in %~
setopt autonamedirs

####################################################################################

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

# From: https://github.com/ohmyzsh/ohmyzsh/blob/95aa9bd97b9fb2a57f355178b2c5f01eb72ad0b6/lib/key-bindings.zsh

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e                                            # Use emacs key bindings

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
fi
if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
fi

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

bindkey ' ' magic-space                               # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

# consider emacs keybindings:

#bindkey -e  ## emacs key bindings
#
#bindkey '^[[A' up-line-or-search
#bindkey '^[[B' down-line-or-search
#bindkey '^[^[[C' emacs-forward-word
#bindkey '^[^[[D' emacs-backward-word
#
#bindkey -s '^X^Z' '%-^M'
#bindkey '^[e' expand-cmd-path
#bindkey '^[^I' reverse-menu-complete
#bindkey '^X^N' accept-and-infer-next-history
#bindkey '^W' kill-region
#bindkey '^I' complete-word
## Fix weird sequence that rxvt produces
#bindkey -s '^[[Z' '\t'
#


__PROMPT_PATH="%~"
__PROMPT_TEXT="${__PROMPT_PATH}"
__PROMPT_BRACKET="%F{%(!.red.white)}[${__PROMPT_TEXT}]%f"
__PROMPT_CHAR="%F{%(?.green.red)}%B%(!.#.$)%b%f"

PROMPT="${__PROMPT_BRACKET}${__PROMPT_CHAR} "

# Custom machine specific fixes
# Define PROMPT_COLOR in here to change the color
# Define PROMPT_HIDE_HOSTNAMES to hide hostnames
source_if_exists $HOME/.customrc

unset -f source_if_exists
unset -f append_path
unset -f prepend_path

source /etc/profile.d/ros-activate.sh