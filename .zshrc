
# Fix when setenv isn't available, should probably just move to export at some
# point.
setenv() {
  export $1=$2
}

if [[ -z $ZSH_VERSION ]]
then
  ZSH_VERSION=`$SHELL --version | /usr/bin/cut -d ' ' -f 2`
fi

# Source all files in .zshrc.d
foreach i (`ls -1 ~/.zshrc.d/*.zsh | gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"`) {
  source $i
}

# I'm leaving this here for now, but it really should be somehwere else
if [ -f "$HOME/.env-improvement/shellhook.sh" ]; then . "$HOME/.env-improvement/shellhook.sh"; fi # [[EI SHELL SETUP]]

export PATH=~/bin:$PATH
