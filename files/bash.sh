printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

fg256color() {
    printf "\[\033[1;38;5;${1}m\]"
}
bg256color() {
    printf "\[\033[48;5;${1}m\]"
}
color8_16() {
    printf "\[\033[${1}m\]"
}

RED=196
WHITE=15
DGRAY=250
RESET="\[\033[0m\]"
YELLOW=220
BLUE=27
ORANGE=208
OG_WHITE=37

# Option 1 (Blue 32, Purple 99)
# Option 2 (Green 23, Tan 95)
# Option 3 ()
# Option 4 ()
# Option 5 ()

HL=$'\u2500'
VL=$'\u2502'
R_TRI=$'\u25B7'
L_SEP=$'\u2524'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DFLAG=$'\u0394'

if [[ $- == *i* ]]; then
    CMOD=$(( $(date +%s) % 5 ))

C1=$(fg256color 15)
C2=$(fg256color 32)
C3=$(fg256color 99)
C4=$(fg256color 250)

prompt() {
    EC=$?

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

