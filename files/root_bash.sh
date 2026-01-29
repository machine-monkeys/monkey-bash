printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

RED="\[\033[1;38;5;196m\]"
TAN="\[\033[1;38;5;95m\]"
GREEN="\[\033[1;38;5;23m\]"
WHITE="\[\033[1;38;5;15m\]"
DGRAY="\[\033[1;38;5;245m\]"
RESET="\[\033[0m\]"
YB="\[\033[38;5;220m\]\[\033[48;5;27m\]"
ORANGE="\[\033[38;5;208m\]"
RWHITE="\[\033[37m\]"

HL=$'\u2500'
VL=$'\u2502'
R_TRI=$'\u25B7'
L_SEP=$'\u2524'
R_SEP=$'\u251C'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DL_RND=$'\u256E'
UL_RND=$'\u256F'
DFLAG=$'\u0394'

prompt() {
    EC=$?

    C1="${WHITE}"
    C2="${GREEN}"
    C3="${TAN}"
    C4="${DGRAY}"

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${ORANGE}${b}"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${RWHITE}${DFLAG}"
        fi
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}"
    else
        F1="${RWHITE}\\A"
    fi

    TOP="${C1}${DR_RND}${L_SEP}${F1}${RESET}${VL}${C2}\\u${RESET}${C1}@${RESET}${C3}\\h${RESET}${C1}:${RESET}${C4}\\W${RESET}${C1}${VL}\\$"

    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    BOT="${C1}${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "
    PS1="${TOP}${BOT}"
}
PROMPT_COMMAND='prompt'

