#!/bin/bash

# Determine user-specific paths
USER_HOME="$HOME"
DOWNLOADS_DIR="$USER_HOME/Downloads"
LABKEYS_DIR="$USER_HOME/labkeys"

# Update placeholders in bash_allies.sh
sed -i.bak "s|__DOWNLOADS_DIR__|$DOWNLOADS_DIR|g" bash_allies.sh
sed -i.bak "s|__LABKEYS_DIR__|$LABKEYS_DIR|g" bash_allies.sh

# Add alias script to user's .bashrc or .zshrc
if [[ -f "$USER_HOME/.bashrc" ]]; then
    echo "source $(pwd)/bash_allies.sh" >> "$USER_HOME/.bashrc"
    echo "Added to .bashrc"
elif [[ -f "$USER_HOME/.zshrc" ]]; then
    echo "source $(pwd)/bash_allies.sh" >> "$USER_HOME/.zshrc"
    echo "Added to .zshrc"
else
    echo "No supported shell configuration file found. Please manually add 'source $(pwd)/bash_allies.sh'."
fi

# Ensure directories exist
mkdir -p "$DOWNLOADS_DIR" "$LABKEYS_DIR"

echo "Setup complete. Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply changes."
