# Monkey Bash

```bash
# Pip install ansible in virtual environment
python -m venv .venv
source .venv/bin/activate
pip install ansible

# Install for local user
ansible-playbook -i "localhost," -e "user=${USER}" append-bashrc.yml
```

---

See [bash.sh](./files/bash.sh) for current bash prompt iteration.

See also `rainbow` function toggle to draw new color scheme for each new prompt.

Color schemes based on finding a good balance and contrast within RGB values and with a primary and secondary color.

