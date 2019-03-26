## Path to your oh-my-fish.
#set fish_path $HOME/.oh-my-fish
#
## Theme
##set fish_theme idan
#
## Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
## Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
## Example format: set fish_plugins autojump bundler
#set fish_plugins git rails vi-mode battery
#
## Path to your custom folder (default path is $FISH/custom)
##set fish_custom $HOME/dotfiles/oh-my-fish
#
## Load oh-my-fish configuration.
#. $fish_path/oh-my-fish.fish

# Make us the default shell
set SHELL /usr/local/bin/fish

# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/samrossoff/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/samrossoff/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

set -g fish_key_bindings fish_vi_key_bindings

set PATH /Users/samrossoff/bin $PATH /opt/pkgconfig/bin /Users/samrossoff/google-cloud-sdk/bin /Users/samrossoff/play-1.2.5.3
set APPENGINE_HOME /Users/samrossoff/appengine-java-sdk-1.9.34

# BUCK
#set PATH /usr/local/opt/buck/bin $PATH

# Android Setup
set -g -x ANDROID_HOME /usr/local/opt/android-sdk
set -g -x ANDROID_SDK /usr/local/opt/android-sdk
set -g -x ANDROID_NDK_HOME $ANDROID_SDK/ndk-bundle/
set PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH
set ANDROID_HVPROTO ddm

# Rust
set PATH $HOME/.cargo/bin $PATH

# Go
set -g -x GOPATH $HOME/Snapchat/Dev
set PATH /usr/local/opt/go/libexec/bin $PATH $GOPATH/bin

# Env variable
set -g -x JAVA_7_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/
set -g -x JAVA_8_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/

# Teh fuck
eval (thefuck --alias | tr '\n' ';')

# FZF https://github.com/junegunn/fzf
fzf_key_bindings

# Make LS colorize when it prints to LESS
set -g -x CLICOLOR_FORCE 1
#alias ls="ls -GFp"
alias less="less -iR"

alias map="xargs -n1"

alias cuts="cut -d' ' "

function find_in_jar
  if count $argv > /dev/null
    for zip_file in (find . -name '*.jar')
      echo $zip_file":"
      unzip -l $zip_file | grep -i --color=always -R $argv[1]
    end | less -R
  else
    echo "need a target"
  end
end

#Prompt stuff
#I'll refactor this later into it's own file

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set -l cwd $cyan(basename (prompt_pwd))

  # output the prompt, left to right

  # Add a newline before prompts
  #echo -e ""

  # Setup title for screen
  #echo -ne '\033k'
  #echo -ne $argv
  #echo -ne '\033\\'

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Display the current directory name
  #echo -n -s $cwd $normal
  echo -n -s (users) $normal
  echo -n -s '@'
  echo -n -s (hostname -s) $normal


  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch '(' (_git_branch_name) ')'

    if [ (_is_git_dirty) ]
      set git_info $red $git_branch "*"
    else
      set git_info $green $git_branch
    end
    echo -n -s ' ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -n -s ' ] ' $normal

end

function fish_right_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l yellow (set_color -o yellow)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  battery > /dev/null

  if set -q BATTERY_IS_CHARGING
     set_color yellow
     printf '⌁'
  else if set -q BATTERY_IS_PLUGGED
     set_color green
     printf "@"
  end

  if math "$BATTERY_PCT > 50" > /dev/null
    set_color cyan
  else if math "$BATTERY_PCT > 20" > /dev/null
    set_color yellow
  else
    set_color red
  end
  printf '%.0f%% ' $BATTERY_PCT
  set_color normal

  echo -n -s $cyan (prompt_pwd)

  if test $last_status -ne 0
    set_color red
    printf ' %d' $last_status
    set_color normal
  end
end

function git-clean
  git branch | sed 's/^..//' | xargs -n 1 git branch -d
end

function gclean
  gradle clean cleanIdea idea
end

function gmake
#TODO: something clever here with checking for a Makefile first
  gradle jar pmdMain findBugsMain
end

function android-screen-record
  adb shell screenrecord --bugreport /sdcard/screen_record.mp4
end

function android-pull-screen-record
 adb pull /sdcard/screen_record.mp4 ~/Desktop/screen_record.mp4
end


# Taken from 
# https://gist.githubusercontent.com/gerbsen/5fd8aa0fde87ac7a2cae/raw/8c58a3711bc727f9a2d6de87e24cd5768e6a21d1/ssh_agent_start.fish
#
setenv SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end

function peek
    tmux split-window -h -p 33 vim "$argv"; or exit;
end
