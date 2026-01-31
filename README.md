# Monkey Prompts 

```sh
# Pip install ansible in virtual environment
python -m venv .venv
source .venv/bin/activate
pip install ansible

# Install for local user
ansible-playbook -i "localhost," -e "user=${USER}" append-bashrc.yml
```

---

### Bash

```bash


