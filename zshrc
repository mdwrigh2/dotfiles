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

plugins=(git rvm gem pip brew lol node npm)
if [[ -e /etc/zsh_command_not_found ]]; then
  # I think this only exists in ubuntu, but in case anyone else has it
  plugins+=(command-not-found)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

os=$(uname)

export CODE=/usr/local/code

if [ $os = "Darwin" ]; then

  export PATH=/Users/mdwrigh2/code/src/prebuilt/darwin-x86/toolchain/arm-eabi-4.4.3/bin:~/.cabal/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/android/tools:~/android/platform-tools:~/bin/arm-2010q1/bin:~/bin:/usr/texbin:/usr/local/Cellar/python/2.7.1/bin:~/code/google/depot_tools

  export EDITOR=mvim

  alias mvimv="mvim" # I'm constantly screwing this up, no idea why. I'll save myself a couple seconds (zsh autocorrect ftw) by just aliasing it to what I mean

  alias vim="mvim -v" # Use macvim rather than normal vim in the terminal

  ulimit -S -n 1024

  # if appengine exists, stick it on the path
  if [ -d $HOME/code/google/google_appengine ]; then
    export PATH=$HOME/code/google/google_appengine:$PATH
  fi

  # Fix the node path so we can import global modules
  export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules

elif [ $os = "Linux" ]; then

  export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/Android/Sdk/tools:~/Android/Sdk/platform-tools:~/.local/bin:~/.cabal/bin:~/android-ndk/:~/code/third_party/depot_tools:~/.cargo/bin

  # Rebind capslock to escape
  if [ -f $HOME/.xmodmap ]; then
      /usr/bin/xmodmap $HOME/.xmodmap 2&> /dev/null
  fi

  # Bind alt-left and alt-right
  bindkey "^[[1;3C" forward-word
  bindkey "^[[1;3D" backward-word

  export EDITOR=vim

  export LANG=en_US.utf8

  if [ -n "$DISPLAY" ]; then
    export BROWSER=chromium
  fi

else
  # Probably BSD or windows
  echo "Warning: Unrecognized OS"
fi


alias tmux="tmux -2 -u "

if [ "$COLORTERM" = "gnome-terminal" ] && [ -z "$TMUX" ]
then
  export TERM=xterm-256color
fi


alias gcc="gcc -std=c99 -Wall "
alias popd="popd -q"

alias feh="feh --scale-down --auto-zoom"

unalias gb

alias ccode="cd $CODE"
alias caosp="cd $CODE/android/aosp-main"
alias cm="cd $CODE/android/main"
alias cas="caosp && sb"
alias cms="cm && sb"

# Remove autocompletion of users
unsetopt cdablevars
unsetopt auto_name_dirs

# Useful android shortcuts
function agrep() {
    egrep -RIins --exclude="*.html" --exclude="*.jd" --exclude="*.ai" "$@" .
}
alias cfb='cd $(gettop)/frameworks/base'
alias cfn='cd $(gettop)/frameworks/native'
alias ccts='cd $(gettop)/cts'
alias f="find . -iname"
alias sb=". build/envsetup.sh"

# sweedish chef
function bork {
    $@
    local ret=$?
    if [ $ret -ne 0 ]
    then
        echo -e "\e[0;31mFAILURE\e[00m"
    else
        echo -e "\e[0;32mSUCCESS\e[00m"
    fi
    return ret
}

function do_from_base {
    local curdir=$PWD
    croot && $*
    local ret=$?
    if [[ "$PWD" != "$curdir" ]]; then
        popd 2>&1 > /dev/null
    fi
    return ret
}

alias m="bork m"
alias mm="bork mm"
alias mma="bork mma"
alias mmm="bork mmm"
alias mmma="bork mmma"

function syncrestart {
    adb shell remount && adb shell stop && sleep 3 && adb sync && adb shell start
}

function logcat {
   logtee /tmp/log.txt -v threadtime $*
}

function dumpsys {
    adb shell dumpsys $*
}

function logtee {
   file=$1;
   shift;
   adb logcat $* | tee "$file"
}

function stack() {
    do_from_base ./vendor/google/tools/stack $*
}

function fa() {
    do_from_base ./vendor/google/tools/flashall --disable_verity $*
}

function copy-if-file() {
    if [[ -f $1 ]]; then
        echo "cp $1 $2"
        cp $1 $2
    fi
}

alias g="godir"

# Use the typical fd command name if it's installed as fdfind
# https://github.com/sharkdp/fd
if command -v fdfind &> /dev/null; then
    alias fd="fdfind"
fi

# Swap out cat for bat
# https://github.com/sharkdp/bat
if command -v bat &> /dev/null; then
    alias cat="bat"
fi

# Swap out ls for eza
# https://github.com/eza-community/eza
if command -v eza &> /dev/null; then
    alias ls="eza"
fi

# Add fzf key bindings if the directory exists.
# https://github.com/junegunn/fzf
if [ -d /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# Add zoxicde commands (z, zi) if it's installed.
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ru [FLAGS] [LDAPS...]
function ru() {
  cmd="repo upload --cbr -o l=Presubmit-Ready+1 "
  while (($#)); do
    if [[ "$1" == -* ]]; then cmd+="$1 ";
    else cmd+="-o r=$1@google.com "; fi
    shift
  done
  cmd+="."
  yes | eval ${cmd}
}

function rs() {
    repo start "$@" .
}

function setup_tree_env_vars() {
    local ANDROID_TREE_LOCATION="/usr/local/code/android"
    if [ ! -d $ANDROID_TREE_LOCATION ]; then
        return
    fi

    for i in $(ls $ANDROID_TREE_LOCATION); do
        export $i:u:gs/-/_/=$ANDROID_TREE_LOCATION/$i
    done
}

setup_tree_env_vars

function trace() {
    do_from_base ./external/chromium-trace/systrace.py \
        sched freq idle am wm gfx view binder_driver workq sync irq input power "$@"
}

function screenshot() {
    adb shell screencap -p /sdcard/screen.png
    adb pull /sdcard/screen.png $1.png
    adb shell rm /sdcard/screen.png
}

function monitor() {
    local f=$1
    shift;
    while true ; do
        inotifywait -qe close_write $f
        echo "Done!"
        $*
    done;
}

function adb() {
    local pid
    pid=$(pgrep -o adb)
    if [ $? -eq 0 ]; then
        /proc/$pid/exe "$@"
    else
        command adb "$@"
    fi
}

function rebuild-ycm () {
    pushd $ANDROID_BUILD_TOP
    if ! make nothing || ! make -j50 SOONG_GEN_COMPDB=1 SOONG_GEN_COMPDB_DEBUG=1 SOONG_LINK_COMPDB_TO=$ANDROID_BUILD_TOP nothing
    then
        echo "Failed to generate compiler_commands.json file!"
    fi
    popd
}


alias scrot='scrot ~/Pictures/screenshots/screenshot_%y-%m-%d-%T.png'
