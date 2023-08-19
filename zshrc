export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
PATH="$HOME/Library/Python/3.9/bin:$PATH"

. $HOME/Library/Python/3.9/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh


export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion



export PATH="/usr/local/opt/protobuf@3/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

clear
neofetch
