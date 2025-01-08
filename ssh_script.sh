alias ssh='function _ssh2() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh <ip_address>";
        return 1;
    fi;

    local ip_address="$1"
    local key_file="labsuser.pem"
    local downloads_dir="/mnt/c/Users/Alex/Downloads"
    local labkeys_dir="/home/cattail/labkeys"

    # Ensure the labkeys directory exists
    mkdir -p "$labkeys_dir" || { echo "Failed to create labkeys directory"; return 1; };
    echo "Directory $labkeys_dir has been created or already exists.";

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

    # Set permissions for the key file and directory
    chmod 700 "$labkeys_dir" && echo "Permissions for $labkeys_dir set to 700";
    chmod 400 "$labkeys_dir/$key_file" && echo "Permissions for $key_file set to 400";

    # Add host to known_hosts to avoid authenticity prompt

