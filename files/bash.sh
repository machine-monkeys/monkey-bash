printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

fg256color() {
    printf "\[\033[1;38;5;${1}m\]"
}
bg256color() {
    printf "\[\033[48;5;${1}m\]"
}
ansi_esc() {
    printf "\[\033[${1}\]"
}

RED196=196
WHITE=15
GRAY=250
YELLOW=220
BLUE27=27
BLUE32=32
PURPLE=99
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

#if [[ $- == *i* ]]; then
#    CMOD=$(( $(date +%s) % 5 ))

ACCENT_CLR=$(fg256color "$WHITE")
USER_CLR=$(fg256color "$BLUE32")
HOST_CLR=$(fg256color "$PURPLE")
WDIR_CLR=$(fg256color "$GRAY")
REPO_CLR=$(fg256color "$ORANGE")
VENV_CLR=$(fg256color "$YELLOW")$(bg256color "$BLUE27")
ERR_CLR=$(fg256color "$RED196")
RESET=$(ansi_esc "0m")

prompt() {
    EC=$?

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${REPO_CLR}${b}"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${ACCENT_CLR}${DFLAG}"
        fi
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}"
    else
        F1="${ACCENT_CLR}\\A"
    fi

    TOP="${ACCENT_CLR}${DR_RND}${L_SEP}${F1}${RESET}${VL}${USER_CLR}\\u${RESET}${ACCENT_CLR}@${RESET}${HOST_CLR}\\h${RESET}${ACCENT_CLR}:${RESET}${WDIR_CLR}\\W${RESET}${ACCENT_CLR}${VL}\\$"

    if [[ "$EC" != 0 ]]; then
        TOP+="${ERR_CLR} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    BOT="${ACCENT_CLR}${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "
    PS1="${TOP}${BOT}"
}
PROMPT_COMMAND='prompt'

