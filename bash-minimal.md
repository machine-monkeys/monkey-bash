# Monkey Custom Dev Bash Prompt

```bash
### Begin Bash Prompt ### 
# Blinking Block Cursor
printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

# ANSI Escape Variables
RED="\[\033[1;38;5;196m\]"
BLUE="\[\033[3;34m\]"
BBLU="\[\033[1;94m\]"
WHITE="\[\033[1;38;5;15m\]"
PURP="\[\033[1;38;5;105m\]"
DGRAY="\[\033[1;38;5;8m\]"
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

    C1="${WHITE}"
    C2="${BBLU}"
    C3="${DGRAY}"
    C4="${BLUE}"

    # Top Setup
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${ORANGE}${b}${RESET}"
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}${RESET}"
    else
        F1="\\A"
    fi
    TOP="${DR_RND}${L_SEP}${F1}${RESET}${VL}${C2}\\u${RESET}${C1}@${RESET}${C3}\\h${RESET}${C1}:${RESET}${C4}\\W${RESET}${C1}${VL}\\$"

    # Append Non-Zero Exit Code
    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    # Bot Setup
    BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "

    # Final
    PS1="${TOP}${BOT}"
}

PROMPT_COMMAND='prompt'
### End Bash Prompt ###
```
