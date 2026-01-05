# Get OS and architecture
function get_os() {
    case "$OSTYPE" in
        darwin*)  echo "macos" ;;
        linux*)   echo "linux" ;;
        msys*|cygwin*|mingw*) echo "windows" ;;
        *)        echo "unknown" ;;
    esac
}

function get_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64) echo "amd64" ;;
        i386|i686)    echo "i386" ;;
        arm64|aarch64) echo "arm64" ;;
        *)           echo "unknown" ;;
    esac
}

function install_font_zip(){
    # Usage:
    # install_font_zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"

    # Check if the URL is provided
    if [ -z "$1" ]; then
    echo "Please provide a URL to a font zip file."
    exit 1
    fi

    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)

    # Download the font zip file
    wget -O "$TEMP_DIR/font.zip" "$1"

    # Unzip the font file
    unzip "$TEMP_DIR/font.zip" -d "$TEMP_DIR"

    # Move the font files to the system fonts directory
    [[ -d $HOME/.local/share/fonts ]] || mkdir -p $HOME/.local/share/fonts
    mv "$TEMP_DIR"/*.{ttf,otf} $HOME/.local/share/fonts/

    # Update the font cache
    fc-cache -f -v

    # Clean up
    rm -rf "$TEMP_DIR"

    echo "Fonts installed successfully!"
}

function manual_install() {
    # Usage: manual_install <url> <binary_name> <destination_dir>
    local url="$1"
    local bin_name="$2"
    local dest_dir="$3"
    local executable="$4"

    echo "-----------------------------------------------------------------------"
    echo "Installing $bin_name from $url to $dest_dir"
    if [[ -z "$url" || -z "$bin_name" || -z "$dest_dir" ]]; then
        echo "Usage: manual_install <url> <binary_name> <destination_dir>"
        return 1
    fi
    if [[ ! -d $dest_dir ]]; then
        mkdir -p "$dest_dir" || { echo "Failed to create directory $dest_dir"; return 1; }
    fi

    echo "Downloading $bin_name from $url"
    TMPDIR=$(mktemp -d)
    cd "$TMPDIR" || { echo "Failed to change directory to $TMPDIR"; return 1; }
    trap 'rm -rf "$TMPDIR"' EXIT  # Ensure cleanup on exit

    curl -sL "$url" -o downloaded_archive || { echo "Download failed!"; return 1; }

    if [[ "$url" == *.zip ]]; then
        unzip -o downloaded_archive || { echo "Unzip failed!"; return 1; }
        rm -rf downloaded_archive
    elif [[ "$url" == *.tar.gz ]] || [[ "$url" == *.tgz ]]; then
        tar -xzf downloaded_archive || { echo "tar extraction failed!"; return 1; }
        rm -rf downloaded_archive
    else
        echo "not archive type."
        mv downloaded_archive "$bin_name" || { echo "rename failed!"; return 1; }
        echo "copying file to $dest_dir"
    fi

    if [[ "$bin_name" == "*" ]]; then
        if [[ "$executable" == "exec" || "$executable" == "executable" ]]; then
            chmod +x ./*
        fi
        mv ./* "$dest_dir"/ || { echo "Move failed!"; cd -; rm -rf "$TMPDIR"; return 1; }
    else
        if [[ "$executable" == "exec" || "$executable" == "executable" ]]; then
            chmod +x "$bin_name" || { echo "chmod failed!"; cd -; rm -rf "$TMPDIR"; return 1; }
        fi
        mv "$bin_name" "$dest_dir"/ || { echo "Move failed!"; cd -; rm -rf "$TMPDIR"; return 1; }
    fi
    echo "$bin_name installed to $dest_dir"
    cd -
}

function run_install_script() {
    # Usage: run_install_script <url> <destination> [run_cmd]
    # This function clones a repository and runs its install script.
    # default run_cmd is "./install.sh"

    local url="$1"
    local dest="$2"
    local run_cmd="$3"
    if [[ $# -gt 3 ]]; then
        shift 3
        run_cmd="$run_cmd $*"
    fi
    echo "-----------------------------------------------------------------------"
    echo "Installing from $url to $dest"
    [[ -z "$url" || -z "$dest" ]] && { echo "Usage: run_install_script <url> <destination> [run_cmd]"; return 1; }
    if [[ -d "$dest" ]]; then
        echo "Directory $dest already exists. Cleanup..."
        rm -rf "$dest"
    fi
    git clone --depth 1 "$url" "$dest" || { echo "Failed to clone repository $url"; return 1; }
    if [[ -d "$dest" ]]; then
        cd "$dest" || { echo "Failed to change directory to $dest"; return 1; }
        if [[ -n "$run_cmd" ]]; then
            echo "Running command: $run_cmd"
            $run_cmd || { echo "Failed to run command: $run_cmd"; return 1; }
        else
            echo "Running default install script: ./install.sh"
            ./install.sh || { echo "Failed to run install.sh"; return 1; }
        fi
        cd - || { echo "Failed to return to previous directory"; return 1; }
    else
        echo "Destination directory $dest does not exist after cloning."
        return 1
    fi
    echo "$dest Installation completed successfully."
}