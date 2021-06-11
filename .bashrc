# .bashrc
 
# Source global definitions
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
###################
## powerline setup
###################
if [ -f `which powerline-daemon` ]; then  
powerline-daemon -q  
POWERLINE_BASH_CONTINUATION=1  
POWERLINE_BASH_SELECT=1  
fi  
if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]; then  
source /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh  
fi  
###################

# history setup
export HISTSIZE=100000
export HISTFILEZISE=100000

# MyOptions
shopt -s autocd
# Enable options:
#shopt -s cdspell
#shopt -s cdable_vars
#shopt -s checkhash
#shopt -s checkwinsize
shopt -s sourcepath
#shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# User specific aliases and functions

alias ls="ls --color"\
	la="ls -a"\
	ll="ls -l"\
	lll="ls -la"

alias vis="sudo vi"
alias ping="ping -c3"
alias ctl="sudo systemctl"
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'
alias suod='sudo'

#my functions


function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
#########################################################################
#########################################################################
#########################################################################
export JFROG_HOME=/srv/containers/artifactoryServer/

### Configure the ANDROID_HOME environment variable
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

#########################################################################
############# riscv-gnu-toolchain #######################################
export PATH=$PATH:/home/rawad/source/riscv-gnu-toolchain
#########################################################################
export PATH=$PATH:/home/rawad/bin

neofetch
