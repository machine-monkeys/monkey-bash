# Cursor Style
printf '\e[1 q' # Shape
printf '\e]12;#D0D0D0\a' # Color

# Notes
# 1. random select dominant color
# 2. random select dominant major or minor
# 3. random select 1 of 3 patterns DML, DMM, DLL
# 4. random select major or minor for secondary colors

# Helper Functions
coin_flip() {
    case $((RANDOM % 2)) in
        0) printf '%s' "$1" ;;
        1) printf '%s' "$2" ;;
    esac
}
tri_flip() {
    case $((RANDOM % 3)) in
        0) printf '%s' "$1" ;;
        1) printf '%s' "$2" ;;
        2) printf '%s' "$3" ;;
    esac
}
mag_flip() {
  case $((RANDOM % 5)) in
    0) printf '%s' 1 ;;
    1) printf '%s' 6 ;;
    2) printf '%s' 36 ;;
    3) printf '%s' 72 ;;
    4) printf '%s' 108 ;;
  esac
}
calc216() {
    local R=$1 G=$2 B=$3 calc
    calc=$((16 + 36*R + 6*G + B))
    printf '%s' "$calc"
}
random_color1() {
    RANDOM=$(( $(date +%s%N) % 32768 ))
    DOM=$(tri_flip "red" "green" "blue")
    PATTERN=$(tri_flip "dml" "dmm" "dll")
    DOM_VAL=$(coin_flip 4 5)
    
    if [[ "$PATTERN" == "dml" ]]; then
        MED_VAL=$(coin_flip 2 3)
        LOW_VAL=$(coin_flip 0 1)
        case "$DOM" in
            red) if [[ $(coin_flip 0 1) == 0 ]]; then calc216 "$DOM_VAL" "$MED_VAL" "$LOW_VAL"; else calc216 "$DOM_VAL" "$LOW_VAL" "$MED_VAL"; fi ;;
            green) if [[ $(coin_flip 0 1) == 0 ]]; then calc216 "$MED_VAL" "$DOM_VAL" "$LOW_VAL"; else calc216 "$LOW_VAL" "$DOM_VAL" "$MED_VAL"; fi ;; 
            blue) if [[ $(coin_flip 0 1) == 0 ]]; then calc216 "$MED_VAL" "$LOW_VAL" "$DOM_VAL"; else calc216 "$LOW_VAL" "$MED_VAL" "$DOM_VAL"; fi ;;
        esac

    elif [[ "$PATTERN" == "dmm" ]]; then
        MED_VAL1=$(coin_flip 2 3)
        MED_VAL2=$(coin_flip 2 3)
        case "$DOM" in
            red) calc216 "$DOM_VAL" "$MED_VAL1" "$MED_VAL2" ;;
            green) calc216 "$MED_VAL1" "$DOM_VAL" "$MED_VAL2" ;;
            blue) calc216 "$MED_VAL1" "$MED_VAL2" "$DOM_VAL" ;;
        esac
    else
        LOW_VAL1=$(coin_flip 0 1)
        LOW_VAL2=$(coin_flip 0 1)
        case "$DOM" in
            red) calc216 "$DOM_VAL" "$LOW_VAL1" "$LOW_VAL2" ;;
            green) calc216 "$LOW_VAL1" "$DOM_VAL" "$LOW_VAL2" ;;
            blue) calc216 "$LOW_VAL1" "$LOW_VAL2" "$DOM_VAL" ;;
        esac
    fi
}
random_color2() {
    local COLOR1=$1 mag dir op opcheck COLOR2
    mag=$(mag_flip)
    dir=$(coin_flip -1 1)
    op=$(( mag * dir ))
    opcheck=$(( COLOR1 + op ))
    if (( opcheck < 16 || opcheck > 231 )); then
        COLOR2=$(( COLOR1 - op ))
    else
        COLOR2=$opcheck
    fi
    printf '%s' "$COLOR2"
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

C1=$(random_color1)
C2=$(random_color2 "$C1")

FLIP=$(coin_flip 0 1)

case "$FLIP" in
    0) UC="$C1" HC="$C2" ;;
    1) UC="$C2" HC="$C1" ;;
esac

ACCENT_CLR=$(fg216 15)
USER_CLR=$(fg216 "$UC" "$BOLD")
HOST_CLR=$(fg216 "$HC" "$BOLD")
WDIR_CLR=$(fg216 250 "$BOLD")
REPO_CLR=$(fg216 250 "$BOLD")
DFLAG_CLR=$(fg216 196 "$BOLD")
VENV_CLR=$(fg216 220)$(bg216 27)
ERR_CLR=$(fg216 196)
RESET=$(ansi_esc "0m")

RAINBOW_MODE=true

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
        C1=$(random_color1)
        C2=$(random_color2 "$C1")
        USER_CLR=$(fg216 "$C1" "$BOLD")
        HOST_CLR=$(fg216 "$C2" "$BOLD")
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

