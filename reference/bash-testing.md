# Monkey Custom Dev Bash Prompt

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
WHT="\[\033[97m\]"
BLACK="\[\033[90m\]"
RESET="\[\033[0m\]"

# Other Colors
YB="\[\033[1;33;44m\]"
ORANGE="\[\033[38;5;208m\]"

# Unicode Code Variables
HL=$'\u2500'
VL=$'\u2502'
R_TRI=$'\u25B7'
L_SEP=$'\u2524'
R_SEP=$'\u251C'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DL_RND=$'\u256E'
UL_RND=$'\u256F'

prompt() {
    EC=$?
    hr=$(date +%H)
    hr=$((10#$hr))

    # Color Control
    if (( hr % 2 == 0)); then
        CLRS=('91' '92' '94')
    else
        CLRS=('96' '95' '93')
    fi

    C1="\[\033[${CLRS[0]}m\]"
    C2="\[\033[${CLRS[1]}m\]"
    C3="\[\033[${CLRS[2]}m\]"

    # Top Setup + Python Virtual Enviornment
    if [[ -n ${VIRTUAL_ENV-} ]]; then 
        VENV="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}${RESET}"
        TOP="${DR_RND}${L_SEP}${VENV}${VL}\\A${VL}${C1}\\u${WHT}@${C2}\\h${WHT}:${C3}\\W${WHT}${VL}\\$"
    else
        TOP="${DR_RND}${L_SEP}\\A${VL}${C1}\\u${WHT}@${C2}\\h${WHT}:${C3}\\W${WHT}${VL}\\$"
    fi

    # Append Non-Zero Exit Code
    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    # Bot Setup + Git Repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && BOT="${UR_RND}${HL}{${ORANGE}${b}${RESET}}${HL}${HL}${R_TRI}${RESET} "
    else
        BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "
    fi

    # Final
    PS1="${TOP}${BOT}"
}

PROMPT_COMMAND='prompt'
### End Bash Prompt ###
````
