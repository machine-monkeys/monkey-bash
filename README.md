# Monkey Prompts 

Shell prompts for use. 

```sh
# Pip install ansible in virtual environment
python -m venv .venv
source .venv/bin/activate
pip install ansible

# Install for local user
ansible-playbook -i "localhost," -c local -e "user=${USER}" shell.yml
```

---

### Bash

```bash
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
BLUE44=44
BLUE45=45
BLUE73=73
BROWN94=94
BROWN95=95
GRAY232=232
GRAY234=234
GRAY235=235
GRAY245=245
GRAY246=246
GRAY250=250
GRAY252=252
GREEN10=10
GREEN22=22
GREEN23=23
GREEN30=30
GREEN29=29
GREEN48=48
GREEN108=108
ORANGE130=130
ORANGE172=172
ORANGE208=208
PINK163=163
PINK212=212
PURPLE93=93
PURPLE99=99
RED160=160
RED196=196
RED198=198
WHITE15=15
YELLOW100=100
YELLOW184=184
YELLOW220=220

# Use UNIX Epoch for random selection
if [[ $- == *i* ]]; then
    CLR_MOD=$(( $(date +%s) % 8 ))
fi

# Pick color based on epoch time result
case "$CLR_MOD" in
    "0") UC="$BLUE32" HC="$PURPLE99" ;;
    "1") UC="$GREEN29" HC="$BROWN94" ;;
    "2") UC="$YELLOW100" HC="$GREEN30" ;;
    "3") UC="$BLUE44" HC="$PINK212" ;;
    "4") UC="$BLUE73" HC="$GREEN108" ;;
    "5") UC="$RED160" HC="$YELLOW184" ;;
    "6") UC="$PURPLE93" HC="$RED198" ;;
    "7") UC="$BLUE45" HC="$ORANGE172" ;;
esac

ACCENT_CLR=$(fg256color "$WHITE15")
USER_CLR=$(fg256color "$UC" "$BOLD")
HOST_CLR=$(fg256color "$HC" "$BOLD")
WDIR_CLR=$(fg256color "$GRAY250" "$BOLD")
REPO_CLR=$(fg256color "$BLACK16" "$BOLD")$(bg256color "$GRAY250")
DFLAG_CLR=$(fg256color "$BLACK16" "$BOLD")
VENV_CLR=$(fg256color "$YELLOW220")$(bg256color "$BLUE27")
ERR_CLR=$(fg256color "$RED196")
RESET=$(ansi_esc "0m")

prompt() {
    EC=$?

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=""
        [[ -n "$b" ]] && F1="${REPO_CLR}${b}"
        if ! git diff --quiet --ignore-submodules -- || ! git diff --quiet --cached --ignore-submodules --; then
            F1+="${DFLAG_CLR}${DFLAG}"
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
```

