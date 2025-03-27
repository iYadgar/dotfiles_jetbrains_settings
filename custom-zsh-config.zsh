# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# source $(brew --prefix nvm)/nvm.sh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export NODE_OPTIONS=--max_old_space_size=8192



ZSH_THEME="robbyrussell"


plugins=(git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

function test() {
    if [ $# -eq 2 ]; then
        z bob; npx nx test $1 --include $2 --watch
    elif [ $# -eq 1 ]; then
        z bob; npx nx test $1 --watch
    else
        echo "Usage: test <arg1> [arg2]"
    fi
}
function start() {
    if [ $# -eq 1 ]; then
        z bob; npm run $1
    else
        z bob; npm run start
    fi
}
alias edit="code ~/.zshrc"
alias re="source ~/.zshrc"
alias w="webstorm"
alias open="z hibob; w ."
alias --help=""
alias --l=""
alias --list=""
alias cl="clear"
alias gc="nx g c -c OnPush --standalone true --style scss"


