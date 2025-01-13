#!/bin/bash

# Variables
BASHRC="$HOME/.bashrc"
BASH_ALIASES="$HOME/.bash_aliases"
SSH_SCRIPT="$HOME/.ssh_script"
LABKEYS_DIR="$HOME/labkeys"

# Remove ~/.ssh_script
if [ -f "$SSH_SCRIPT" ]; then
    echo "Removing $SSH_SCRIPT..."
    rm "$SSH_SCRIPT"
else
    echo "No $SSH_SCRIPT file found to remove."
fi

# Remove alias from ~/.bash_aliases
if [ -f "$BASH_ALIASES" ]; then
    echo "Removing alias from ~/.bash_aliases..."
    sed -i '/alias ssh=/d' "$BASH_ALIASES"
else
    echo "No ~/.bash_aliases file found."
fi

# Remove sourcing of ~/.bash_aliases from ~/.bashrc
if [ -f "$BASHRC" ]; then
    echo "Removing sourcing of ~/.bash_aliases from ~/.bashrc..."
    sed -i '/if \[ -f ~/.bash_aliases \]/,+2d' "$BASHRC"
else
    echo "No ~/.bashrc file found."
fi

# Optionally, remove the labkeys directory
if [ -d "$LABKEYS_DIR" ]; then
    echo "Removing labkeys directory at $LABKEYS_DIR..."
    rm -r "$LABKEYS_DIR"
else
    echo "No labkeys directory found."
fi

# Reload shell configuration
echo "Undo complete! Reloading shell configuration..."
source "$BASHRC"

echo "All changes have been reverted."

