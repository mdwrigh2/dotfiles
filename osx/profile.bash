
# MacPorts Installer addition on 2008-07-06_at_19:03:36: adding an appropriate PATH variable for use with MacPorts.
export PATH=:~/bin:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


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
alias gcc='gcc -Wall -std=c99'
alias ccsc='cd /Users/mwright/School/CSC230'
alias ccode='cd /Users/mwright/code'
alias cprotopipe='cd /Users/mwright/code/work/mdwrigh2/protopipe'
alias cops='cd /Users/mwright/code/work/mdwrigh2/protops'
alias cegoless='cd /Users/mwright/code/groups/egoless'
alias cschool='cd /Users/mwright/School'
export RUBYOPT="rubygems"
alias sl='ls'

# Setting default compile flags for make
export CFLAGS="-Wall -std=c99"

# Setting up Go env variables
export GOROOT=$HOME/go
export GOOS=darwin
export GOARCH=386
export GOBIN=$HOME/bin

# Setup EC2 variables
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=pk-FZ4TWUDV2NZPX7QQRR2ASUNB7HSPD2JW.pem
export EC2_CERT=cert-FZ4TWUDV2NZPX7QQRR2ASUNB7HSPD2JW.pem
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
