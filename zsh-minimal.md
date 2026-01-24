# Monkey Custom Zsh Prompt

```zsh
### Begin Zsh Prompt ### 
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
    local TOP BOT
    local RED="%B%F{196}"
    local BLU="%I%F{20}"
    local LBLU="%F{32}"
    local WHT=$'%F{15}'
    local ORNG="F%{208}"
    local YB="%F{226}%K{27}"

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n $b ]] && F1="${ORNG}${b}%b%f"
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}%f%k%b"
    else
        F1="%D{%H:%M}"

    TOP="${WHT}${DR_RND}${L_SEP}${F1}${VL}${LG}%n${WHT}@${DG}%m${WHT}:${BLU}%1~${WHT}${VL}"

    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}%b%f"$'\n'
    else
        TOP+=$'\n'
    fi

    BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}%f "

    PROMPT="${TOP}${BOT}"
}
### End Zsh Prompt ###
```
