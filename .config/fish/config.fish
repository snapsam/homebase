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


# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/samrossoff/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/samrossoff/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

fish_vi_mode

set PATH $PATH /opt/pkgconfig/bin /Users/samrossoff/google-cloud-sdk/bin /Users/samrossoff/play-1.2.5.3 /Users/samrossoff/bin
set -x GOPATH ~/gocode/
set APPENGINE_HOME /Users/samrossoff/appengine-java-sdk-1.9.9


# Env variable
set JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home

# Teh fuck
eval (thefuck --alias | tr '\n' ';')

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
  echo -ne '\033k'
  echo -ne $argv
  echo -ne '\033\\'

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
