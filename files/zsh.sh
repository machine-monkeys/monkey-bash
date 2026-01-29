precmd() {
    local EC=$?
    printf '\e[1 q'
    printf '\e]12;#D0D0D0\a'
    local HL=$'\u2500'
    local VL=$'\u2502'
    local L_SEP=$'\u2524'
    local R_TRI=$'\u25B7'
    local DR_RND=$'\u256D'
    local UR_RND=$'\u2570'
    local DFLAG=$'\u0394'
    local TOP BOT
    local RED="%F{196}"
    local PURP="%F{99}"
    local BLUE="%F{32}"
    local DG="%F{245}"
    local WHT="%F{15}"
    local ORNG="%F{208}"
    local YB="%F{220}%K{27}"
    local C1 C2 C3

    C1="${BLUE}"
    C2="${PURP}"
    C3="${DG}"

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n $b ]] && F1="${ORNG}${b}%f"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${DFLAG}"
        fi
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}%f%k"
    else
        F1="%D{%H:%M}"
    fi
    TOP="${WHT}${DR_RND}${L_SEP}${F1}${VL}${C1}%n${WHT}@${C2}%m${WHT}:${C3}%1~${WHT}${VL}"

    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}%f"$'\n'
    else
        TOP+=$'\n'
    fi
    BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}%f "

    PROMPT="${TOP}${BOT}"
}
