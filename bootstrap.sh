#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/8tm/ansible-client.git"
DIR="ansible-client"

# 1) Zainstaluj git, python3 oraz pip (jeśli brak)
which git &>/dev/null || sudo apt-get update && sudo apt-get install -y git
which python3 &>/dev/null || sudo apt-get install -y python3
which pip3 &>/dev/null || sudo apt-get install -y python3-pip

# 2) Sklonuj repo (lub pull, jeśli już istnieje)
if [ -d "$DIR" ]; then
  echo "Repozytorium istnieje, wykonuję git pull…"
  cd "$DIR"
  git pull
else
  git clone "$REPO_URL" "$DIR"
  cd "$DIR"
fi

# 3) Zainstaluj Ansible, jeśli nie ma
if ! command -v ansible-playbook &>/dev/null; then
    echo "Instalacja Ansible…"
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
fi

# 4) (opcjonalnie) Zainstaluj role z Galaxy, jeśli masz requirements.yml
if [ -f requirements.yml ]; then
    ansible-galaxy install -r requirements.yml
fi

# 5) Uruchom playbook
ansible-playbook playbook.yml
