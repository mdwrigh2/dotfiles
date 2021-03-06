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

  function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }
  ulimit -S -n 1024

  # if appengine exists, stick it on the path
  if [ -d $HOME/code/google/google_appengine ]; then
    export PATH=$HOME/code/google/google_appengine:$PATH
  fi

  # Fix the node path so we can import global modules
  export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules

elif [ $os = "Linux" ]; then

  export PATH=/opt/scala-2.8.1.final/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda/bin:~/Android/Sdk/tools:~/Android/Sdk/platform-tools:~/bin/arm-2010q1/bin:~/bin:~/.cabal/bin:~/android-ndk/:~/code/third_party/depot_tools

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

export GOPATH=$HOME/code/go
export GOROOT=$HOME/code/third_party/go

export PATH=$GOROOT/bin:$PATH:$PLAN9/bin

export NODE_PATH=/usr/local/lib/node:$NODE_PATH

if [ "$COLORTERM" = "gnome-terminal" ] && [ -z "$TMUX" ]
then
  export TERM=xterm-256color
fi


[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

function no_git {
  export PS1="%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $ "
}

function no_git_off {
  source $ZSH/oh-my-zsh.sh
}


alias gcc="gcc -std=c99 -Wall "
alias popd="popd -q"

alias feh="feh --scale-down --auto-zoom"

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

alias ccode="cd $CODE"
alias caosp="cd $CODE/android/aosp"
alias cm="cd $CODE/android/master"
alias cms="cm && sb"
alias cnyc="cd $CODE/android/nyc-mr1-dev"
alias cns="cnyc && sb"
alias coc="cd $CODE/android/oc-mr1-dev"
alias cos="coc && sb"
alias ck="cd $CODE/kernel"

# Always use GOMA when available
export USE_GOMA=true

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

function psu {
    mm -j20  && adb sync && \
    echo "Killing SystemUI..." && \
    adb shell ps | grep -i com.android.systemui | awk '{print $2}' | xargs adb shell kill && \
    sleep 1 && \
    echo "Restarting SystemUI..." && \
    adb shell am startservice -n com.android.systemui/.SystemUIService
}

function fmake () {
    do_from_base mmm -j24 $* frameworks/base frameworks/base/core/res frameworks/base/core/jni frameworks/base/libs/input frameworks/native/libs/ui frameworks/native/libs/input frameworks/native/services/inputflinger frameworks/native/services/surfaceflinger frameworks/base/services frameworks/base/policy
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

alias fmake="bork fmake"
alias mm="bork mm"
alias m="bork m"
alias mma="bork mm"

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

function pt() {
  if [[ -z "$ANDROID_PRODUCT_OUT" ]]; then
    echo "No product set. Run lunch."
    return 1
  fi

  local curdir=$PWD
  croot && \
  mmm -j24 external/libvterm packages/apps/Terminal && \
      adb install -r $ANDROID_PRODUCT_OUT/system/app/Terminal.apk && \
      adb shell am start -n com.android.terminal/.TerminalActivity
  local ret=$?
  cd $curdir
  return ret
}

function stack() {
    do_from_base ./vendor/google/tools/stack $*
}

function fa() {
    do_from_base ./vendor/google/tools/flashall --disable_verity $*
}

function ptouch() {
    if [[ -z "$1" ]]; then
        echo "argument missing: ptouch requires a path to the firmware image"
        return 1
    fi
    adb push $HOME/Downloads/iap_0322 /data/ && \
        adb push "$1" /data/ && \
        adb shell chmod 770 /data/iap_0322 && \
        adb shell /data/iap_0322 -n 1 -f /data/$(basename "$1")
}

function swipe() {
    local t="$1"||1000
    adb shell input touchscreen swipe 0 300 1000 300 "$t" && \
        adb shell input touchscreen swipe 1000 300 0 300 "$t"
}

alias killmonkey='adb shell ps | grep monkey | awk '\''{print $2}'\'' | xargs adb shell kill'

function kmake() {
    ARCH=arm64 CROSS_COMPILE=${ANDROID_TOOLCHAIN%/}/aarch64-linux-android- make
}

function copy-if-file() {
    if [[ -f $1 ]]; then
        echo "cp $1 $2"
        cp $1 $2
    fi
}

function cwk() {
    if [[ -z "$1" ]]; then
        echo "argument missing: $0 requires a name for the device to copy to"
        return 1
    fi

    copy-if-file $CODE/kernel/arch/arm64/boot/Image.lz4-dtb $1/
    copy-if-file $CODE/kernel/arch/arm64/boot/dtbo.img $1/
    find $CODE/kernel/drivers -name "*.ko" | xargs --verbose -I args cp args $1/
}

function astudio() {
    $HOME/android-studio/bin/android $HOME/android-studio/bin/studio.sh
}

function flash() {
    cd $HOME/flashstation/ && \
    curl -L http://android_flashstation.corp.google.com/android_flashstation.par -O && \
    chmod +x android_flashstation.par && \
    XDG_DATA_HOME=$HOME/.local/share BROWSER=google-chrome $HOME/flashstation/android_flashstation.par
}

alias g="godir"
alias ru='yes | repo upload --cbr .'

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

function player_led() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: player_led [file] [led]"
        return 1
    fi
    node=$1
    player=$2;
    for i in {0..3}; do
        if [ "$i" = "$player" ]; then
            adb shell sendevent $node 17 $i 1
        else
            adb shell sendevent $node 17 $i 0
        fi
    done
}

function setup_trace() {
    adb root && adb wait-for-device && adb shell "echo 1 > /d/tracing/events/mdss/enable"
}

function trace() {
    do_from_base ./external/chromium-trace/systrace.py \
        sched freq idle am wm gfx view binder_driver workq sync irq input power "$@"
}

function run_cts() {
    cts-tradefed run commandAndExit cts-dev $@
}

function screenshot() {
    adb shell screencap -p /sdcard/screen.png
    adb pull /sdcard/screen.png $HOME/Downloads/$1.png
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

function run_apicheck() {
    do_from_base /bin/bash -c "out/host/linux-x86/bin/apicheck -JXmx1024m -J\"classpath /usr/lib/jvm/java-8-openjdk-amd64/bin/../lib/tools.jar:out/host/linux-x86/framework/doclava.jar:out/host/linux-x86/framework/jsilver.jar\"  -hide 2 -hide 3 -hide 4 -hide 5 -hide 6 -hide 24 -hide 25 -hide 26 -hide 27 -error 7 -error 8 -error 9 -error 10 -error 11 -error 12 -error 13 -error 14 -error 15 -error 16 -error 17 -error 18   prebuilts/sdk/api/26.txt  out/target/common/obj/PACKAGING/public_api.txt  frameworks/base/api/removed.txt  out/target/common/obj/PACKAGING/removed.txt"
}

function arm64env() {
    export ARCH=arm64
    export CROSS_COMPILE=aarch64-linux-android-
    export CLANG_TRIPLE=$(echo $CROSS_COMPILE | sed -e 's/android.*-/gnu-/')
    export PATH=$MASTER/prebuilts/clang/host/linux-x86/clang-stable/bin:$PATH
    export PATH=$MASTER/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
    export PATH=$MASTER/prebuilts/misc/linux-x86/dtc:$PATH
    export PATH=$MASTER/prebuilts/misc/linux-x86/lz4:$PATH
    export PATH=$MASTER/prebuilts/misc/linux-x86/libufdt:$PATH
    export PATH=$MASTER/prebuilts/misc/linux-x86/yasm:$PATH
}
