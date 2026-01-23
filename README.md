# Monkey Custom Bash Prompt

```bash
### Begin Bash Prompt ### 
# Blinking Block Cursor
printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

# ANSI Escape Variables
RED="\[\033[91m\]"
GREEN="\[\033[92m\]"
BLUE="\[\033[94m\]"
CYAN="\[\033[96m\]"
MAGENTA="\[\033[95m\]"
YELLOW="\[\033[93m\]"
WHITE="\[\033[97m\]"
BLACK="\[\033[90m\]"
RESET="\[\033[0m\]"

# Color Combos
YB="\[\033[1;33;44m\]"

# 256 Colors
ORANGE="\[\033[38;5;208m\]"

# Unicode Code Variables
DR_CORNER=$'\u250C'
UR_CORNER=$'\u2514'
HL=$'\u2500'
VL=$'\u2502'
R_ARROW=$'\u2192'
R_TRI=$'\u25B7'
L_TRI=$'\u25C1'
L_SEP=$'\u2524'
R_SEP=$'\u251C'
T_CON=$'\u2534'
B_CON=$'\u252c'
CIRC=$'\u25EF'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DL_RND=$'\u256E'
UL_RND=$'\u256F'

# 3-Color Scheme Arrays
RGB=('91' '92' '94')
CMY=('96' '95' '93')

__git_branch() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
    git symbolic-ref --quiet --short HEAD 2>/dev/null || return 1
}

prompt() {
    EC=$?
    hr=$(date +%H)
    hr=$((10#$hr))

    if (( hr % 2 == 0)); then
        CLRS=( "${RGB[@]}" )
    else
        CLRS=( "${CMY[@]}" )
    fi

    C1="\[\033[${CLRS[0]}m\]"
    C2="\[\033[${CLRS[1]}m\]"
    C3="\[\033[${CLRS[2]}m\]"

    TOP="${DR_RND}${L_SEP}\\A${VL}${C1}\\u${WHITE}@${C2}\\h${WHITE}:${C3}\\W${WHITE}${VL}"
    if b="$(__git_branch)"; then TOP+="${ORANGE}${b}${RESET}${VL}"; fi
    if [[ -n ${VIRTUAL_ENV-} ]]; then TOP+="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}${RESET}${VL}"; fi
    TOP+="${EC}${VL}\\$\\n"

    BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "

    PS1="${TOP}${BOT}"
}

PROMPT_COMMAND='prompt'
### End Bash Prompt ###
````
