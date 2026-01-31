# Cursor Style
printf '\e[1 q' # Shape
printf '\e]12;#D0D0D0\a' # Color

# Helper Functions
roll_rand() {
    i=$(( RANDOM % $# + 1))
    ROLL=${!i}
    printf '%s' "$ROLL"
}
calc216() {
    local R=$1 G=$2 B=$3 calc
    calc=$((16 + 36*R + 6*G + B))
    printf '%s' "$calc"
}
fg216() {
    if [[ -n "${2-}" ]]; then
        mode="${2};"
    else
        mode=""
    fi
    printf "\[\033[${mode}38;5;${1}m\]"
}
bg216() {
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

# Color Channels
chan1=$(roll_rand 1 4)
chan2=$(( 5 - chan1 ))
ctrl_chan=$(roll_rand 2 3)

C1=$(calc216 "$chan1" "$ctrl_chan" "$chan2")
C2=$(calc216 "$chan2" "$ctrl_chan" "$chan1")

FLIP=$(roll_rand 0 1)
case "$FLIP" in
    0) UC="$C1" HC="$C2" ;;
    1) UC="$C2" HC="$C1" ;;
esac

ACCENT_CLR=$(fg216 15)
USER_CLR=$(fg216 "$UC" "$BOLD")
HOST_CLR=$(fg216 "$HC" "$BOLD")
WDIR_CLR=$(fg216 250 "$BOLD")
VENV_CLR=$(fg216 250 "$BOLD")
REPO_CLR=$(fg216 250 "$BOLD")
DFLAG_CLR=$(fg216 196)
ERR_CLR=$(fg216 196)
RESET=$(ansi_esc "0m")

RAINBOW_MODE=false
rainbow() {
    case "$RAINBOW_MODE" in
        false) RAINBOW_MODE=true ;;
        true) RAINBOW_MODE=false ;;
        *) RAINBOW_MODE=false
    esac
}

prompt() {
    local EC=$? b
    F1=""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${REPO_CLR}${b}"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${DFLAG_CLR}${DFLAG}"
        fi
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${VENV_CLR}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}"
    else
        F1="${ACCENT_CLR}\\A"
    fi

    if $RAINBOW_MODE; then
        chan1=$(roll_rand 0 1 2 3 4 5)
        chan2=$(( 5 - chan1 ))
        ctrl_chan=$(roll_rand 1 2 3 4)
        
        C1=$(calc216 "$chan1" "$ctrl_chan" "$chan2")
        C2=$(calc216 "$chan2" "$ctrl_chan" "$chan1")
        
        FLIP=$(roll_rand 0 1)
        case "$FLIP" in
            0) UC="$C1" HC="$C2" ;;
            1) UC="$C2" HC="$C1" ;;
        esac
        USER_CLR=$(fg216 "$UC" "$BOLD")
        HOST_CLR=$(fg216 "$HC" "$BOLD")
    fi

    TOP="${ACCENT_CLR}${DR_RND}${L_SEP}${F1}${RESET}${VL}${USER_CLR}\\u${RESET}${ACCENT_CLR}@${RESET}${HOST_CLR}\\h${RESET}${ACCENT_CLR}:${RESET}${WDIR_CLR}\\W${RESET}${ACCENT_CLR}${VL}\\$"

    if (( EC != 0 )); then
        TOP+="${ERR_CLR} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    BOT="${ACCENT_CLR}${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "
    PS1="${TOP}${BOT}"
}
PROMPT_COMMAND='prompt'

