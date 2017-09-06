#!/bin/bash

if [[ -z $MARKPATH ]]; then
    MARKPATH=$HOME/.marks
fi
mkdir -p $MARKPATH

RED="\033[0;31m"
GREEN="\033[0;33m"
WHITE="\033[00m"

function J() {
    case $1 in
        "")
            _J_list
            ;;
        -s)
            _J_save $2
            ;;
        -d)
            _J_delete $2
            ;;
        -*)
            _J_usage
            ;;
        *)
            _J_go $1
            ;;
    esac
}

function _J_usage {
    echo "Usage:"
    echo "  J           - Lists all marks"
    echo "  J <mark>    - Goes (cd) to the directory associated with <mark>"
    echo "  J -s <mark> - Saves the current directory as <mark>"
    echo "  J -d <mark> - Deletes the <mark>"
    kill -SIGINT $$
}

function _J_list {
    arr=(`ls $MARKPATH`)
    for link in ${arr[@]}; do
        printf "${GREEN}%-20s${WHITE} %s\n" "$link" "`readlink "$MARKPATH/$link" |sed "s#^$HOME#~#"`"
	  done
}

function _J_go {
    if ( _J_mark_valid $1 ); then
        _J_mark_link $1
        if [[ -n $J_LINK ]]; then
            cd $J_LINK
            return 0
        fi
        echo -e "No such mark: $RED$1$WHITE"
    fi
    return 1
}

function _J_save {
    if ( _J_mark_valid $1 ); then
        _J_mark_link $1
        if [[ -z $J_LINK ]]; then
            ln -s $PWD "$MARKPATH/$1"; return 0
        fi
        echo -e "Exists mark: $RED$1$WHITE"
    fi
    return 1
}

function _J_delete {
    if ( _J_mark_valid $1 ); then
        _J_mark_link $1
        if [[ -n $J_LINK ]]; then
            rm "$MARKPATH/$1"; return 0
        fi
        echo -e "No such mark: $RED$1$WHITE"
    fi
    return 1
}


function _J_mark_valid {
    if [[ -z $1 ]]; then
        echo "Mark required"; return 1
    elif [[ $1 != `echo $1 |sed 's/ //g'` ]]; then
        echo "Mark is not valid"; return 1
    fi
}

function _J_mark_link {
    J_LINK=`readlink $MARKPATH/$1`
}

# completion command
function _J_comp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`ls $MARKPATH`' -- $curw))
}

# ZSH completion command
function _J_compzsh {
    reply=(`ls $MARKPATH`)
}

if [[ -n $ZSH_VERSION ]]; then
    compctl -K _J_compzsh J
else
    shopt -s progcomp
    complete -F _J_comp J
fi
