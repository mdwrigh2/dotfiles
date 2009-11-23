    if [ -f /opt/local/etc/bash_completion ]; then
        . /opt/local/etc/bash_completion
    fi

#source ~/.git-completion.bash
source ~/.bashrc

if [ -f ~/.profile ]; then
. ~/.profile
fi

# MacPorts Installer addition on 2008-07-06_at_19:03:36: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

source /opt/local/etc/bash_completion.d/git
# MacPorts Installer addition on 2008-07-06_at_19:03:36: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH
# Finished adapting your MANPATH environment variable for use with MacPorts.

export CATALINA_HOME=~/Work/apache-tomcat-5.5.26
export JAVA_HOME=/usr
export C_INCLUDE_PATH=/opt/local/include
export LIBRARY_PATH=/opt/local/lib
alias ls='/bin/ls -G'
export LSCOLORS=exfxcxdxbxegedabagacad
export EDITOR='mate -w'
HISTFILESIZE=1000000000 HISTSIZE=1000000



#if [ "$(type -t __git_ps1)" ]; then
#    PS1="\$(__git_ps1 '(%s)')$PS1"
#fi

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "⎌"
}
 
function parse_git_branch {
  local branch=$(__git_ps1 "%s")
  [[ $branch ]] && echo " ($branch$(parse_git_dirty))"
}
 
PS1='[\u@\h \W$(parse_git_branch " (%s)")]\$ '
