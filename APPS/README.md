# APPS — App Installers

Each `.app` file in this directory is **sourced** (not executed) by
`install.sh` in a specific order.  Every file runs in the same shell
process, so they share exported variables and can call helper functions
declared in `../functions`.

---

## Execution order

`install.sh` iterates the directory in glob order, so the numeric prefix
controls install sequence.  Lower numbers run first.

```bash
APPS/
├── 1.nvm.app          # must be first — other tools may need Node
├── 2.tmux.app         # shell multiplexer, no hard deps
├── 3.tmuxAddons.app   # reads ~/.tmux.conf written by 2.tmux.app
├── 4.vim.app          # text editor
├── 5.zshAddons.app    # oh-my-zsh, plugins (shell must exist)
├── copilot.app        # GitHub Copilot CLI (needs Node from 1.nvm.app)
├── eza.app            # ls replacement; also patches exports
├── fzf.app            # fuzzy finder; also patches exports
├── helm.app           # Kubernetes package manager
├── k8s.app            # kubectl, kubeadm, completions
├── k9s.app            # Kubernetes TUI
├── nerdFonts.app      # icon fonts (no other app depends on this)
└── yh.app             # Yaml Highlighter (standalone binary)
```

When adding a new app, pick the next available number, or insert between
existing ones if ordering matters (e.g. a tool that depends on another).

---

## File contract

Every `.app` file **must**:

```bash
echo "--- Installing <Tool Name>"
# ... install logic ...
echo "--- <Tool Name> installed successfully"
```

The opening `---` line is printed by `install.sh` as `>>> Installing <path>`
*before* sourcing; the closing line is the file's own responsibility.

Failure is handled gracefully — `install.sh` prints `exit code: $?` on
failure and continues to the next app.  **Never call `exit 1`** inside an
`.app` file; use `return 1` so sourcing continues.

---

## Available helpers (`../functions`)

| Helper | What it does |
|---|---|
| `is_termux` | Returns 0 (true) when running under Termux (Android). |
| `get_os` | Prints `macos`, `linux`, `android`, or `windows(wsl)`. |
| `get_arch` | Prints `amd64`, `arm64`, `i386`, or `unknown`. |
| `install_font_zip <url>` | Downloads a zip, moves `.ttf`/`.otf` to `~/.local/share/fonts/`, refreshes `fc-cache`. |
| `manual_install <url> <bin_name> <dest_dir> [executable]` | Downloads any archive or single binary, moves to `dest_dir`, optionally `chmod +x`. |
| `run_install_script <url> <dest> [cmd]` | `git clone` + run an install script inside the clone. |
| `append_block_once <file> <tag> <content>` | Appends `content` to `file` only when `tag` is not already present. Useful for injecting PATH / env exports into `exports`. |

---

## Patching exported config (the `LOCALDIST_*` pattern)

Some apps need to add lines to `exports`, `aliases`, or `zshrc` that will
be copied into `~` at the end of the run.

Declare the target at the top of the file using a safe-default assignment
(`:=` means "set only if not already set"):

```bash
: "${LOCALDIST_EXPORTS:=./exports}"          # → localdist/.config/dotfiles/exports
: "${LOCALDIST_ALIASES:=./aliases}"          # → localdist/.config/dotfiles/aliases
: "${LOCALDIST_BASHRC:=./SHELLS/BASH/bashrc}"
: "${LOCALDIST_ZSHRC:=./SHELLS/ZSH/zshrc}"
```

The variables point into `localdist/` (the staging dir `build_localdist`
creates), so modifications land in the copy that gets installed to `~`,
**not** the source file in this repo.

Good practice: wrap new blocks in sentinel tags so they can be replaced
on re-run without accumulating duplicates:

```bash
FZF_BLOCK='#[DOTFILES_FZF]
export FZF_DEFAULT_OPTS="..."
#[/DOTFILES_FZF]'

# Remove the old block (idempotent — no error if absent)
sed -i '/^#\[DOTFILES_FZF\]$/,/^#\[\/DOTFILES_FZF\]$/d' "$LOCALDIST_EXPORTS" 2>/dev/null
append_block_once "$LOCALDIST_EXPORTS" "#[DOTFILES_FZF]" "$FZF_BLOCK"
```

---

## Minimal template

Copy this skeleton and fill in the three sections:

```bash
## install <Tool Name>
# One-line description of what this app does and why it exists.

echo "--- Installing <Tool Name>"

# ── Version ───────────────────────────────────────────────────────────────────
# Pin the release so every platform gets the same build.  Leave unset if the
# app always pulls latest (e.g. from a package manager).
VERSION="1.2.3"

# ── Platform branches ─────────────────────────────────────────────────────────
if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS — Homebrew
    brew install <package>

elif is_termux; then
    # Termux (Android)
    pkg install -y <package>

elif [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*release)" ]; then
    # Debian / Ubuntu / Mint (includes WSL)
    # Prefer downloading a pinned release binary over a distro package when
    # the distro version lags or doesn't support the architecture.
    manual_install \
        "https://github.com/org/tool/releases/download/v${VERSION}/tool-linux-amd64.zip" \
        tool \
        "$HOME/.local/bin" \
        executable
fi

echo "--- <Tool Name> installed successfully"
```

---

## Updating an existing app

1. **Bump the version string** (if the app pins one).
2. **Check the upstream release page** for renamed assets or new platform
   binaries — asset slugs are case-sensitive and must match exactly.
3. **Run `install.sh`** (`PACKAGING_START=y` to skip the dependency prompt)
   and watch the output for this app's section.
4. **Verify** the tool works in a fresh shell: `command -v <tool>` should
   resolve to `~/.local/bin/<tool>` or the Homebrew path.
5. **Update this README** if the app's behavior or platform support changed.

---

## Naming conventions

| Element | Convention | Example |
|---|---|---|
| File | `<order>.<lowercase-name>.app` | `4.vim.app` |
| Echo banner | `--- Installing <Title Case Name>` | `--- Installing VIM` |
| Variable prefix | `` `PACKAGE_NAME` / `PACKAGE_VERSION` / `REQUIRED_VERSION` / `VERSION` `` | `VERSION="3.5.0"` |
| Platforms | `` `darwin*`, `is_termux`, `linux-gnu*` / `debian` / `ubuntu` / `mint` `` | see any existing file |
