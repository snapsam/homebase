# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='vim'


# Setup history
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000

setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "

# Don't find dups (note, I still write them)
setopt HIST_FIND_NO_DUPS

# setup Github token
export GITHUB_TOKEN=`cat ~/.config/gh/github.token`
