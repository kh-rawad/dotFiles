
## install Fonts
echo "--- Installing Fonts"

# ── Version ───────────────────────────────────────────────────────────────────
# Pin the Nerd Fonts release so every platform pulls the same set of glyphs.
# Update this string when you want to upgrade; the rest of the file adapts
# automatically.
# Releases: https://github.com/ryanoasis/nerd-fonts/releases
VERSION="3.5.0"

# ── Fonts list ────────────────────────────────────────────────────────────────
# Every family listed here is installed on every platform (macOS, Termux,
# Debian/Ubuntu/Mint).  Adding or removing a font is a single-line change.
# Names must match the GitHub release asset slug exactly, e.g.:
#   https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.0/<NAME>.zip
FONTS_LIST=(
    "Hack"
    "FiraCode"
    "JetBrainsMono"
    "SourceCodePro"
    "0xProto"
)

# ── Platform branches ─────────────────────────────────────────────────────────
if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS — Homebrew Cask
    # ─────────────────────────────────────────────────────────────────────────
    # The 'font-*' casks live in the homebrew/cask-fonts tap and accept the
    # kebab-case, lower-case form of the family name, e.g.:
    #   Hack          → font-hack-nerd-font
    #   SourceCodePro → font-sourcecodepro-nerd-font
    brew tap homebrew/cask-fonts

    for font in "${FONTS_LIST[@]}"; do
        # Convert PascalCase → kebab-case (portable: BSD/GNU sed).
        kebab="$(echo "$font" | sed 's/[A-Z]/-&/g; s/^-//' | tr '[:upper:]' '[:lower:]')"
        cask_name="font-${kebab}-nerd-font"
        brew install --cask "$cask_name"
    done

elif is_termux; then
    # Termux (Android)
    # ─────────────────────────────────────────────────────────────────────────
    # fontconfig provides fc-match / fc-cache which eza and other Nerd-Font-
    # aware tools rely on to look up glyphs at runtime.
    pkg install -y fontconfig

    for font in "${FONTS_LIST[@]}"; do
        # Each font is a single zip asset in the tagged GitHub release.
        # install_font_zip (declared in functions) handles download, extraction,
        # placement under ~/.local/share/fonts/, and cache refresh.
        install_font_zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION}/${font}.zip"
    done

elif [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*release)" ]; then
    # Debian / Ubuntu / Mint (also covers WSL)
    # ─────────────────────────────────────────────────────────────────────────
    # The distro packages (fonts-hack-nerd, etc.) lag behind the upstream
    # release and don't cover every family in FONTS_LIST, so we download
    # each zip directly from the pinned release instead.
    for font in "${FONTS_LIST[@]}"; do
        install_font_zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION}/${font}.zip"
    done
fi

echo "--- Fonts installed successfully"