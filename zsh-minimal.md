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
    local RED="%B%F{red}"
    local BLU="%F{blue}"
    local WHT=$'%{\e[38;5;255m%}' 
    local DG=$'%{\e[38;5;240m%}'
    local LG=$'%{\e[38;5;250m%}'

    TOP="${WHT}${DR_RND}${L_SEP}%D{%H:%M}${VL}${LG}%n${WHT}@${DG}%m${WHT}:${BLU}%1~${WHT}${VL}"

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
