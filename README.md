# Monkey Custom Dev Bash Prompt

```bash
### Begin Bash Prompt ### 
# Blinking Block Cursor
printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

# ANSI Escape Variables
RED="\[\033[91m\]"
BLUE="\[\033[34m\]"
WHITE="\[\033[97m\]"
LGRAY="\[\033[38;5;248m\]"
DGRAY="\[\033[38;5;242m\]"

RESET="\[\033[0m\]"

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

count=0
prompt() {
    EC=$?

    C1="${WHITE}"
    C2="${LGRAY}"
    C3="${DGRAY}"
    C4="${BLUE}"

    # Top Setup
    TOP="${DR_RND}${L_SEP}\\A${VL}${C2}\\u${C1}@${C3}\\h${C1}:${C4}\\W${C1}${VL}\\$"

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
