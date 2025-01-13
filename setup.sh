#!/bin/bash

# Variables
BASHRC="$HOME/.bashrc"
BASH_ALIASES="$HOME/.bash_aliases"
SSH_SCRIPT="$HOME/.ssh_script"
LABKEYS_DIR="$HOME/labkeys"

# Ensure this script is executed from the directory where it resides
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "Starting setup..."

# 1. Move .ssh_script to the home directory
if [ -f "$SCRIPT_DIR/ssh_script" ]; then
    echo "Moving ssh_script to $SSH_SCRIPT..."
    mv "$SCRIPT_DIR/ssh_script" "$SSH_SCRIPT" || { echo "Failed to move ssh_script."; exit 1; }
    chmod +x "$SSH_SCRIPT" # Ensure the script is executable
else
    echo "ssh_script not found in $SCRIPT_DIR. Please ensure the file is present."
    exit 1
fi

# 2. Create labkeys directory if it doesn't exist
if [ ! -d "$LABKEYS_DIR" ]; then
    echo "Creating labkeys directory at $LABKEYS_DIR..."
    mkdir -p "$LABKEYS_DIR" || { echo "Failed to create labkeys directory."; exit 1; }
else
    echo "Labkeys directory already exists at $LABKEYS_DIR."
fi

# 3. Add alias to ~/.bash_aliases
if [ ! -f "$BASH_ALIASES" ]; then
    echo "Creating ~/.bash_aliases file..."
    touch "$BASH_ALIASES"
fi

if ! grep -q "alias ssh=" "$BASH_ALIASES"; then
    echo "Adding alias to ~/.bash_aliases..."
    echo "alias ssh='source ~/.ssh_script; _ssh2'" >> "$BASH_ALIASES"
else
    echo "Alias for ssh already exists in ~/.bash_aliases."
fi

# 4. Ensure .bash_aliases is sourced in ~/.bashrc
if ! grep -q "if [ -f ~/.bash_aliases ]" "$BASHRC"; then
    echo "Adding sourcing of ~/.bash_aliases to ~/.bashrc..."
    echo -e "\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi" >> "$BASHRC"
fi

# Reload shell configuration
echo "Setup complete! Reloading shell configuration..."
source "$BASHRC"

echo "Setup complete. You can now use the ssh command with your .pem key."

