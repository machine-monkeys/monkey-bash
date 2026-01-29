# Cursor Style
printf '\e[1 q' # Shape
printf '\e]12;#D0D0D0\a' # Color

# Helper Functions
fg256color() {
    if [[ -n "${2-}" ]]; then
        mode="${2};"
    else
        mode=""
    fi
    printf "\[\033[${mode}38;5;${1}m\]"
}
bg256color() {
    if [[ -n "${2-}" ]]; then
        mode="${2};"
    else
        mode=""
    fi
    printf "\[\033[${mode}48;5;${1}m\]"
}
ansi_esc() {
    printf "\[\033[${1}\]"
}

# Box Drawing Unicodes
HL=$'\u2500'
VL=$'\u2502'
R_TRI=$'\u25B7'
L_SEP=$'\u2524'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DFLAG=$'\u0394'

# Mode Codes
BOLD=1
DIM=2
ITALIC=3
UNDERLINE=4
BLINK=5
REVERSE=7
HIDDEN=8
STRIKETHRU=9

# 256 Color Codes
BLACK16=16
BLUE17=17
BLUE27=27
BLUE32=32
GRAY250=250
GREEN23=23
GREEN48=48
ORANGE208=208
PURPLE99=99
TAN95=95
RED196=196
WHITE15=15
YELLOW220=220

# Use UNIX Epoch for random selection
if [[ $- == *i* ]]; then
    CLR_MOD=$(( $(date +%s) % 3 ))
fi

# Pick color based on epoch time result
case "$CLR_MOD" in
    0) UC="$BLUE32" HC="$PURPLE99" ;;
    1) UC="$GREEN23" HC="$TAN95" ;;
    2) UC="$YELLOW220" HC="$BLUE27" ;;
    *) UC="$BLACK16" HC="$WHITE15" ;;
esac

ACCENT_CLR=$(fg256color "$WHITE15")
USER_CLR=$(fg256color "$UC" "$BOLD")
HOST_CLR=$(fg256color "$HC" "$BOLD")
WDIR_CLR=$(fg256color "$GRAY250" "$BOLD")
REPO_CLR=$(fg256color "$ORANGE208")
VENV_CLR=$(fg256color "$YELLOW220")$(bg256color "$BLUE27")
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

