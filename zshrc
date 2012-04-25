# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="clean"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
 export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(git rails3 ruby rvm gem pip brew lol node npm)
if [[ -e /etc/zsh_command_not_found ]]; then
  # I think this only exists in ubuntu, but in case anyone else has it
  plugins+=(command-not-found)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

os=$(uname)

if [ $os = "Darwin" ]; then

  export PATH=~/.cabal/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/android/tools:~/android/platform-tools:~/bin/arm-2010q1/bin:~/bin:/usr/texbin:/usr/local/Cellar/python/2.7.1/bin:~/code/google/depot_tools

  export EDITOR=mvim

  alias mvimv="mvim" # I'm constantly screwing this up, no idea why. I'll save myself a couple seconds (zsh autocorrect ftw) by just aliasing it to what I mean

  alias vim="mvim -v" # Use macvim rather than normal vim in the terminal

  function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }
  ulimit -S -n 1024


elif [ $os = "Linux" ]; then

  export PATH=/opt/scala-2.8.1.final/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/android/tools:~/android/platform-tools:~/bin/arm-2010q1/bin:~/bin:~/.cabal/bin

  alias apt-get-suggests-install="sudo apt-get -o APT::Install-Suggests=\"true\" -o APT::Install-Recommends=\"true\" install"

  # Rebind capslock to escape
  if [ -f $HOME/.xmodmap ]; then
      /usr/bin/xmodmap $HOME/.xmodmap 2&> /dev/null
  fi

  if [ -d /opt/java6/bin ]; then
    export PATH=/opt/java6/bin:$PATH
    # I know this is going to eventually break something, but I'm pretty sure it's going to break building android now
    export JAVA_HOME=/opt/java6
  fi

  export EDITOR=vim
  alias sudo="sudo -E" # have sudo retain my environment

  export LANG=en_US.utf8

  if [ -n "$DISPLAY" ]; then
    export BROWSER=chromium
  fi

else
  # Probably BSD or windows
  echo "Warning: Unrecognized OS"
fi


alias tmux="tmux -2 -u "

export PLAN9=/usr/local/plan9
export PATH=~/go/bin:$PATH:$PLAN9/bin

export GOPATH=$HOME/code/go
export GOROOT=$HOME/go

export NODE_PATH=/usr/local/lib/node:$NODE_PATH

if [ "$COLORTERM" = "gnome-terminal" ]
then
  export TERM=xterm-256color
fi


unsetopt auto_name_dirs

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# export PS2="%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $ "
function no_git {
  export PS1="%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $ "
}

function no_git_off {
  source $ZSH/oh-my-zsh.sh
}


alias gcc="gcc -std=c99 -Wall "

export WORKON_HOME=$HOME/.virtualenvs

unalias gb
