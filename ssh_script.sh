#!/bin/bash

# Variables
CUSTOM_BASH_DIR="${HOME}/.bash_custom"
BASH_ALIASES="${HOME}/.bash_aliases"
SCRIPT_NAME="setup_ssh_alias.sh"
SOURCE_LINE="for file in ~/.bash_custom/*.sh; do [ -r \"\$file\" ] && source \"\$file\"; done"

# Create the custom folder if it doesn't exist
echo "Creating custom folder at $CUSTOM_BASH_DIR..."
mkdir -p "$CUSTOM_BASH_DIR"

# Copy the custom script to the custom folder
echo "Copying custom script to $CUSTOM_BASH_DIR..."
cp "./.bash_custom/$SCRIPT_NAME" "$CUSTOM_BASH_DIR/"

# Ensure .bash_aliases exists
if [ ! -f "$BASH_ALIASES" ]; then
    echo "Creating $BASH_ALIASES..."
    touch "$BASH_ALIASES"
fi

# Add sourcing line to .bash_aliases if not already present
if ! grep -q "$SOURCE_LINE" "$BASH_ALIASES"; then
    echo "Adding sourcing line to $BASH_ALIASES..."
    echo "$SOURCE_LINE" >> "$BASH_ALIASES"
else
    echo "Sourcing line already exists in $BASH_ALIASES."
fi

# Make the custom script executable
echo "Ensuring the custom script is executable..."
chmod +x "$CUSTOM_BASH_DIR/$SCRIPT_NAME"

# Reload shell
echo "Reloading shell to apply changes..."
source "$HOME/.bashrc" || source "$HOME/.bash_profile"

echo "Setup complete! You can now use the SSH alias by typing 'ssh <ip_address>'."
