# SSH alias script
alias ssh='function _ssh2() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh <ip_address>";
        return 1;
    fi;

    local ip_address="$1"
    local key_file="labsuser.pem"
    local downloads_dir="__DOWNLOADS_DIR__"
    local labkeys_dir="__LABKEYS_DIR__"

    mkdir -p "$labkeys_dir" || { echo "Failed to create labkeys directory"; return 1; };

    if [ -f "$downloads_dir/$key_file" ]; then
        echo "Found $key_file in Downloads directory. Moving to labkeys...";
        mv "$downloads_dir/$key_file" "$labkeys_dir/" || { echo "Failed to move $key_file"; return 1; };
    fi;

    if [ ! -f "$labkeys_dir/$key_file" ]; then
        echo "$key_file not found in labkeys directory.";
        return 1;
    fi;

    chmod 400 "$labkeys_dir/$key_file" && echo "Permissions for $key_file set to 400";
    /usr/bin/ssh -o StrictHostKeyChecking=no -i "$labkeys_dir/$key_file" ec2-user@"$ip_address" || {
        echo "SSH connection failed";
        rm -f "$labkeys_dir/$key_file";
        return 1;
    }

    rm -f "$labkeys_dir/$key_file";
}; _ssh2'
