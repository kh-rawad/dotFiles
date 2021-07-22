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

if [ -f  /usr/share/powerline/bindings/bash/powerline.sh ]; then
source  /usr/share/powerline/bindings/bash/powerline.sh
fi
###################

# history setup
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend

# MyOptions
shopt -s autocd
# Enable options:
shopt -s cdspell
#shopt -s cdable_vars
#shopt -s checkhash
#shopt -s checkwinsize
shopt -s sourcepath
#shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# User specific aliases and functions
if [ -f ~/dotfiles/functions ]; then
source ~/dotfiles/functions
fi

# my functions
if [ -f ~/dotfiles/aliases ]; then
source ~/dotfiles/aliases
fi

# exports
if [ -f ~/dotfiles/exports ]; then
source ~/dotfiles/exports
fi

neofetch
