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

plugins=(git rails3 rvm gem pip brew lol node npm)
if [[ -e /etc/zsh_command_not_found ]]; then
  # I think this only exists in ubuntu, but in case anyone else has it
  plugins+=(command-not-found)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

os=$(uname)

if [ $os = "Darwin" ]; then

  export PATH=/Users/mdwrigh2/code/src/prebuilt/darwin-x86/toolchain/arm-eabi-4.4.3/bin:~/.cabal/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/android/tools:~/android/platform-tools:~/bin/arm-2010q1/bin:~/bin:/usr/texbin:/usr/local/Cellar/python/2.7.1/bin:~/code/google/depot_tools

  export EDITOR=mvim

  alias mvimv="mvim" # I'm constantly screwing this up, no idea why. I'll save myself a couple seconds (zsh autocorrect ftw) by just aliasing it to what I mean

  alias vim="mvim -v" # Use macvim rather than normal vim in the terminal

  function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }
  ulimit -S -n 1024

  # if appengine exists, stick it on the path
  if [ -d $HOME/code/google/google_appengine ]; then
    export PATH=$HOME/code/google/google_appengine:$PATH
  fi

  # Fix the node path so we can import global modules
  export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules

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

if [ "$COLORTERM" = "gnome-terminal" ] && [ -z "$TMUX" ]
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


# While developing

#zstyle ":completion:*" verbose yes
#zstyle ":completion:*:descriptions" format ‘%B%d%b’
#zstyle ":completion:*:messages" format ‘%d’
#zstyle ":completion:*:warnings" format ‘No matches for: %d’
#zstyle ":completion:*" group-name ”

#fpath=(~/.completions $fpath)

#autoload -U ~/.completions/*(:t)


#r() {
  #local f
  #f=(~/.completions/*(.))
  #unfunction $f:t 2> /dev/null
  #autoload -U $f:t
#}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

alias ccode="cd /usr/local/code/"

# Useful android shortcuts
alias agrep="grep -RIis --exclude=\"*.xml\" --exclude=\"*.html\" --exclude=\"*.jd\""
alias cfb="croot && cd frameworks/base"
alias f="find . -iname"
alias sb=". build/envsetup.sh"

function psu {
    mm -j20  && adb sync && \
    echo "Killing SystemUI..." && \
    adb shell ps | grep -i com.android.systemui | awk '{print $2}' | xargs adb shell kill && \
    sleep 1 && \
    echo "Restarting SystemUI..." && \
    adb shell am startservice -n com.android.systemui/.SystemUIService
}

function fmake () {
    croot && \
    mmm -j24 $* frameworks/base frameworks/base/core/res frameworks/base/core/jni frameworks/base/libs/androidfw frameworks/native/libs/ui frameworks/native/libs/utils frameworks/base/services/java frameworks/base/services/jni frameworks/base/services/input frameworks/base/policy
    local ret=$?
    popd 2>&1 > /dev/null
    return ret
}

function syncrestart {
    adb remount && adb shell stop && sleep 3 && adb sync && adb shell start
}

function logcat () {
   logtee /tmp/log.txt -v threadtime $*
}

function logtee {
   file=$1;
   shift;
   adb logcat $* | tee "$file"
}

alias kmake="ARCH=arm CROSS_COMPILE=arm-eabi- make"

export CCACHE_DIR=/usr/local/code/ccache/
export USE_CCACHE=1
