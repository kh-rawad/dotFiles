echo '>>>Intalling eza'
echo '--- https://github.com/eza-community/eza'
PACKAGE_NAME='eza'
PACKAGE_VERSION='0.23.4'

: "${LOCALDIST_ZSHRC:=./SHELLS/ZSH/zshrc}"

ensure_zsh_fpath_before_compinit() {
    local target_file="$1"
    local fpath_line='fpath=(~/.zfunc $fpath)'
    local tmp_file

    [[ -f "$target_file" ]] || return 0
    grep -qF "$fpath_line" "$target_file" 2>/dev/null && return 0

    tmp_file="$(mktemp)"
    awk -v line="$fpath_line" '
        BEGIN { inserted=0 }
        {
            if (!inserted && ($0 ~ /compinit/ || $0 ~ /source \$ZSH\/oh-my-zsh\.sh/)) {
                print line
                inserted=1
            }
            print
        }
        END {
            if (!inserted) {
                print line
            }
        }
    ' "$target_file" > "$tmp_file" && mv "$tmp_file" "$target_file"
}


if [[ $OSTYPE == 'darwin'* ]]; then
    brew install eza
elif is_termux; then
    pkg install eza
elif [[ $OSTYPE == 'linux-gnu'* ]] && [[ "$(uname -m)" == 'x86_64' ]]; then
    tmp_dir="$(mktemp -d)"

    wget -c "https://github.com/eza-community/eza/releases/download/v${PACKAGE_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" -O - | tar xz -C "$tmp_dir"
    install -Dm755 "$tmp_dir/eza" "${HOME}/.local/bin/eza"

    echo '--- Copy completions scripts (if bundled)'
    wget -c "https://github.com/eza-community/eza/releases/download/v${PACKAGE_VERSION}/completions-${PACKAGE_VERSION}.tar.gz" -O - | tar xz -C "$tmp_dir"

    # target_paths[0] is BASH, target_paths[1] is ZSH
    target_paths=( "${DOTFILES_FOLDER}/SHELLS/"{BASH,ZSH}"/${PACKAGE_NAME}/completions" )
    mkdir -p "${target_paths[@]}" "$HOME/.zfunc"

    bash_completion_src="$(find "$tmp_dir" -type f -name eza | head -n 1)"
    zsh_completion_src="$(find "$tmp_dir" -type f -name _eza | head -n 1)"

    if [[ -n "$bash_completion_src" ]]; then
        cp -f "$bash_completion_src" "${target_paths[0]}/eza"
    fi

    if [[ -n "$zsh_completion_src" ]]; then
        cp -f "$zsh_completion_src" "${target_paths[1]}/_eza"
        cp -f "$zsh_completion_src" "$HOME/.zfunc/_eza"
    fi

    ensure_zsh_fpath_before_compinit "$LOCALDIST_ZSHRC"

    echo '--- Cleanup'
    rm -rf "$tmp_dir"
fi

echo '<<< DONE'
