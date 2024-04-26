ZCONFIG=$HOME/.zconfig
autoload -U compinit; compinit
source $ZCONFIG/completion.zsh
bindkey '^[[Z' reverse-menu-complete

bindkey "^¬" clear-screen

git config --global alias.root 'rev-parse --show-toplevel'

alias passcp="scp -oProxyJump=galileo@192.168.64.1"
# Make remote copying work seamlessly with tmux
if [[ -n "$TMUX" ]] && [[ -z "${SSH_CLIENT-}" ]]; then
    alias ssh='ssh -R 19988:localhost:19988 -o "LocalCommand='$HOME'/.tmux/yank-listener.sh >/tmp/yank-listener.log 2>&1 &"'
fi

if [[ "$(uname)" == "Darwin" ]]; then
    ssh-add --apple-load-keychain 2> /dev/null

    alias ls="gls --color=always"
fi

export HOSTNAME="$(hostname)"
export GITHUB_API_TOKEN=""
export OPENAI_API_KEY=""

# Colours for ls(1)
export CLICOLOR=1
# On macOS it's LSCOLORS but the below one is broken
export LS_COLORS="di=01;38;05;166:ex=38;5;214"
export LSCOLORS="di=01;38;05;166:ex=38;5;214"

# VIM
: which nvim && alias vim="nvim"

# Plugins
## Better History
eval "$(atuin init zsh)"

# Rust Config
source $HOME/.cargo/env

# Golang Config
if [[ "$(uname)" == "Darwin" ]]; then
    # MacPorts
    export GOROOT=/opt/local/lib/go
else
    export GOROOT=/usr/local/go
fi
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Zig Config
export ZIGROOT=$HOME/zig/zig-linux-aarch64-0.10.0/
export PATH=$PATH:$ZIGROOT

# MacPorts Config
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

# Prompt Configuration

function zsh_print_colors() {
	for x in {0..8}; do 
	    for i in {30..37}; do 
	        for a in {40..47}; do 
	            echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
	        done
	        echo
	    done
	done
	echo ""
}

alias zsh_print_colors=zsh_print_colors
autoload -U colors && colors

## SSH Prompt

ssh_info() {
	[[ "$SSH_CONNECTION" != '' ]] && echo "(%F{203}%m%{$reset_color%}) " || echo ''
}

## VCS Prompt 
autoload -Uz vcs_info 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst
zstyle ':vcs_info:*+*:*' debug false
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' disable bzr cdv darcs fossil hg mtn p4 svk tla hg-git hg-hgsubversion hg-hgsvn
zstyle ':vcs_info:*' actionformats "(%a) %r/%b:"
zstyle ':vcs_info:*' formats "%r/%b:" # hash & branch

## Main Prompt
PROMPT='$(ssh_info)%F{208}%n%f in %F{226}%30<...<%~%f $ '

### Add date
RPROMPT='[${vcs_info_msg_0_}%D{%f.%m %H:%M:%S}]'

schedprompt() {
    emulate -L zsh
    zmodload -i zsh/sched

    # Remove existing event, so that multiple calls to
    # "schedprompt" work OK.  (You could put one in precmd to push
    # the timer 30 seconds into the future, for example.)
    integer i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
    (( i )) && sched -$i

    # Test that zle is running before calling the widget (recommended
    # to avoid error messages).
    # Otherwise it updates on entry to zle, so there's no loss.
    zle && zle reset-prompt

    # This ensures we're not too far off the start of the minute
    sched +1 schedprompt
}

schedprompt
