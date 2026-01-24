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
    local hr b C1 C2 C3 TOP BOT VENV
    local WHT="%F{white}"
    local BLK="%F{black}" 
    local YB=$'%{\e[1;33;44m%}'
    local ORANGE=$'%{\e[38;5;208m%}'
    hr=${(%):-%H}
    hr=$((10#$hr))

    if (( hr % 2 == 0)); then 
        C1="%F{red}"
        C2="%F{green}"
        C3="%F{blue}" 
    else 
        C1="%F{cyan}"
        C2="%F{magenta}"
        C3="%F{yellow}"
    fi

    if [[ -n ${VIRTUAL_ENV-} ]]; then 
        VENV="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}%f%k%b"
        TOP="${DR_RND}${L_SEP}${VENV}${VL}%D{%H:%M}${VL}${C1}%n${WHT}@${C2}%m${WHT}:${C3}%1~${WHT}${VL}"
    else
        TOP="${DR_RND}${L_SEP}%D{%H:%M}${VL}${C1}%n${WHT}@${C2}%m${WHT}:${C3}%1~${WHT}${VL}"
    fi

    if [[ "$EC" != 0 ]]; then
        TOP+="%B%F{red} ${EC}%b%f"$'\n'
    else
        TOP+=$'\n'
    fi

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n $b ]] && BOT="${UR_RND}${HL}${WHT}{${ORANGE}${b}%b${WHT}}${HL}${HL}${R_TRI}%f "
    else
        BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}%f "
    fi

    PROMPT="${TOP}${BOT}"
}
### End Zsh Prompt ###
```
