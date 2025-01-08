# SSH alias script with dynamic paths
alias ssh='function _ssh2() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh <ip_address>";
        return 1;
    fi;

    local ip_address="$1"
    local key_file="labsuser.pem"
    local downloads_dir="$HOME/Downloads"
    local labkeys_dir="$HOME/labkeys"

    # Ensure the labkeys directory exists
    if [ ! -d "$labkeys_dir" ]; then
        echo "Labkeys directory does not exist. Creating it at $labkeys_dir...";
        mkdir -p "$labkeys_dir" || { echo "Failed to create labkeys directory"; return 1; };
    fi

    # Check if the key file is in the Downloads directory
    if [ -f "$downloads_dir/$key_file" ]; then
        echo "Found $key_file in Downloads directory. Moving to labkeys...";
        mv "$downloads_dir/$key_file" "$labkeys_dir/" || { echo "Failed to move $key_file"; return 1; };
    fi;

    # Verify the key file exists in the labkeys directory
    if [ ! -f "$labkeys_dir/$key_file" ]; then
        echo "$key_file not found in labkeys directory.";
        return 1;
    fi;

    # Set permissions and attempt SSH without asking to save the host key
    chmod 400 "$labkeys_dir/$key_file" && echo "Permissions for $key_file set to 400";
    /usr/bin/ssh -o StrictHostKeyChecking=no -i "$labkeys_dir/$key_file" ec2-user@"$ip_address" || {
        echo "SSH connection failed";
        rm -f "$labkeys_dir/$key_file";
        return 1;
    }

    # Cleanup key file upon exiting
    rm -f "$labkeys_dir/$key_file";
}; _ssh2'

# Append the alias to the .bash_aliases file if not already added
if ! grep -q "alias ssh='_ssh2'" "$HOME/.bash_aliases"; then
    echo -e "\nalias ssh='_ssh2'" >> "$HOME/.bash_aliases"
    echo "Alias added to .bash_aliases."
else
    echo "Alias already exists in .bash_aliases."
fi

# Prompt user to activate the alias
echo "Run 'source ~/.bash_aliases' to activate the alias."
