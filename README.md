# dotFiles

Personal dotfiles repo for fresh system bootstrapping — shell configs, aliases, functions, and app installers that set up a consistent environment across Termux, macOS, and Debian/Ubuntu-based Linux.

---

## What's in here

| Path                 | Purpose                                                                                     |
| -------------------- | ------------------------------------------------------------------------------------------- |
| `SHELLS/BASH/bashrc` | Bash startup config                                                                         |
| `SHELLS/ZSH/zshrc`   | Zsh startup config                                                                          |
| `aliases`            | Shared shell aliases (eza, tmux, extract, git helpers, etc.)                                |
| `exports`            | PATH, locale, and editor defaults                                                           |
| `functions`          | Reusable bash functions (`get_os`, `is_termux`, `run_install_script`, font installer, etc.) |
| `abbreviations`      | Vim-style abbreviations for the shell                                                       |
| `tmux.conf`          | Tmux configuration                                                                          |
| `vimrc`              | Vim configuration                                                                           |
| `setEnv`             | Environment bootstrap — sets `DOTFILES_FOLDER`, `SYSTEM_INFO`, sources `functions`          |
| `APPS/`              | Per-application installers (sourced, not executed)                                          |
| `PREFS/`             | Post-install preferences (git config, shell finalization)                                   |

The config files are installed to:

- `~/.bashrc`
- `~/.zshrc`
- `~/.config/dotfiles/` (for aliases, exports, functions, abbreviations)

---

## Quick start

```bash
# clone
git clone git@github.com:kh-rawad/dotFiles.git ~/dotFiles
cd ~/dotFiles

# bootstrap (prompts for dependency install, then runs app + preference installers)
./install.sh
```

On a fresh system, `setEnv` detects the OS/arch and `install.sh` handles the rest.

---

## How install.sh works

1. **Detects system** — `setEnv` calls `get_os` + `get_arch` from `functions` and exports `SYSTEM_INFO`. The script bails early with a clear message if detection fails.

2. **Installs dependencies** (optional, interactive) — Offers to install base tools via the right package manager:
   - **Termux**: `pkg install vim curl wget git zsh tmux nodejs-lts stow unzip`
   - **macOS**: `brew install vim curl wget git tmux stow`
   - **Debian/Ubuntu/Mint**: `apt install vim curl wget git zsh unzip stow bison libevent-dev`
   - Skippable — set `PACKAGING_START` to any value to bypass the prompt.

3. **Builds a local dist** — Assembles a temporary `localdist/` tree with the right file layout:

   ```bash
   localdist/
   ├── .bashrc
   ├── .zshrc
   └── .config/dotfiles/
       ├── aliases
       ├── exports
       └── functions
   ```

4. **Runs app installers** — Sources every file in `APPS/` in order. Each `.app` file is responsible for installing one tool (nvm, vim, tmux, zsh, fzf, k9s, helm, etc.). Failures are reported but don't stop the run.

5. **Runs preferences** — Sources every file in `PREFS/` to apply post-install settings (git config, shell finalization).

6. **Installs dotfiles** — Copies the assembled `localdist/` contents into `~` and `$DOTFILES_FOLDER` (default `~/.config/dotfiles`).

---

## Supported platforms

| Platform               | `$SYSTEM_INFO`                    | Package manager                  |
| ---------------------- | --------------------------------- | -------------------------------- |
| Android (Termux)       | `android-amd64` / `android-arm64` | `pkg`                            |
| macOS                  | `macos-amd64` / `macos-arm64`     | `brew`                           |
| Debian / Ubuntu / Mint | `linux-amd64` / `linux-arm64`     | `apt`                            |
| WSL                    | `windows(wsl)-amd64`              | `apt` via the Linux distribution |

---

## Directory layout

```
dotFiles/
├── install.sh            # Main bootstrap script
├── setEnv                # Sets DOTFILES_FOLDER, SYSTEM_INFO, sources functions
├── package.sh            # Packaging helper
├── aliases               # Shared shell aliases
├── exports               # PATH, locale, EDITOR defaults
├── functions             # Core helper functions + install utilities
├── abbreviations         # Shell abbreviations (iabbrev syntax)
├── tmux.conf             # Tmux config
├── vimrc                 # Vim config
├── SHELLS/
│   ├── BASH/bashrc       # Bash RC (sourced into ~/.bashrc)
│   └── ZSH/zshrc         # Zsh RC (sourced into ~/.zshrc)
├── APPS/                 # Per-app installers (sourced by install.sh)
│   ├── 1.nvm.app
│   ├── 2.tmux.app
│   ├── 3.tmuxAddons.app
│   ├── 4.vim.app
│   ├── 5.zshAddons.app
│   ├── copilot.app
│   ├── eza.app
│   ├── fzf.app
│   ├── helm.app
│   ├── k8s.app
│   ├── k9s.app
│   └── nerdFonts.app
├── PREFS/                # Post-install preference scripts
│   ├── git.pref
│   └── shell.pref
└── .config/dotfiles/     # Installed here at runtime (generated)
```

---

## Notes

- `.env` / `.env.local` files exist and are gitignored — keep secrets out of the repo.
- App installers in `APPS/` are **sourced**, not executed — they share the parent shell's environment and can use the helper functions in `functions`.
- Pref scripts in `PREFS/` run after all apps are installed; use them for things that need the full toolchain present (e.g. git config, shell plugin activation).
