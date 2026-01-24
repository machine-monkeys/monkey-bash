# Monkey Prompts

Shell prompts that I use. Currently just `bash` and `zsh`

```sh
# Install locally
ansible-playbook shell.yml -i localhost, -c local -K -b
```

---

### Bash

```bash
printf '\e[1 q'
printf '\e]12;#D0D0D0\a'

RED="\[\033[1;38;5;196m\]"
PURP="\[\033[1;38;5;99m\]"
BLUE="\[\033[1;38;5;32m\]"
WHITE="\[\033[1;38;5;15m\]"
DGRAY="\[\033[1;38;5;245m\]"
RESET="\[\033[0m\]"
YB="\[\033[38;5;220m\]\[\033[48;5;27m\]"
ORANGE="\[\033[38;5;208m\]"

HL=$'\u2500'
VL=$'\u2502'
R_TRI=$'\u25B7'
L_SEP=$'\u2524'
R_SEP=$'\u251C'
DR_RND=$'\u256D'
UR_RND=$'\u2570'
DL_RND=$'\u256E'
UL_RND=$'\u256F'
DFLAG=$'\U0394'

prompt() {
    EC=$?

    C1="${WHITE}"
    C2="${BLUE}"
    C3="${PURP}"
    C4="${DGRAY}"

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${ORANGE}${b}${RESET}"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${DFLAG}"
        fi
    elif [[ -n ${VIRTUAL_ENV-} ]]; then 
        F1="${YB}${VIRTUAL_ENV_PROMPT:-(${VIRTUAL_ENV##*/})}${RESET}"
    else
        F1="\\A"
    fi

    TOP="${DR_RND}${L_SEP}${F1}${RESET}${VL}${C2}\\u${RESET}${C1}@${RESET}${C3}\\h${RESET}${C1}:${RESET}${C4}\\W${RESET}${C1}${VL}\\$"

    if [[ "$EC" != 0 ]]; then
        TOP+="${RED} ${EC}${RESET}\\n"
    else
        TOP+="\\n"
    fi

    BOT="${UR_RND}${HL}${HL}${HL}${R_TRI}${RESET} "
    PS1="${TOP}${BOT}"
}
PROMPT_COMMAND='prompt'
```

## ZSH

```zsh
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
```

