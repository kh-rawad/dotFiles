# Copilot Instructions

## Build, test, and lint

- Primary integration command: `./install.sh`
  - This is the main entrypoint used by CI in `.github/workflows/blank.yml`.
  - It is not a dry run: it copies files into `$HOME` and `~/.config/dotfiles`, may prompt for dependency installation, and installs plugins/fonts/tools.
- Packaging command: `./package.sh`
  - This stages an install into a temporary `HOME`, sets `PACKAGING_START=true`, runs `./install.sh`, then creates `dotfiles_package_*.tar.gz`.
- CI smoke test:
  - `./install.sh`
  - `source ~/.bashrc`
- Linting is configured in GitHub Actions via MegaLinter in `.github/workflows/staging.yml`.
  - There is no checked-in local lint wrapper command.
- There is no checked-in unit/integration test suite or single-test runner.
  - For targeted validation, prefer file-scoped shell checks such as `bash -n install.sh package.sh setEnv functions` before running the full installer in a disposable environment.

## High-level architecture

- This repository is a shell-centric dotfiles bundle, not an application codebase. The main flow is:
  1. `setEnv` sources the shared `functions` library, sets `DOTFILES_FOLDER="$HOME/.config/dotfiles"`, and derives `SYSTEM_INFO` from `get_os`/`get_arch`.
  2. `install.sh` uses that bootstrap state to copy the repo-managed shared files (`aliases`, `exports`, `functions`) into `$DOTFILES_FOLDER`, install shell rc files into `$HOME`, and then install OS-specific dependencies, fonts, tmux plugins, Vim plugins, and a few standalone tools.
  3. Runtime shell behavior comes from `SHELLS/BASH/bashrc` and `SHELLS/ZSH/zshrc`, which both source the copied shared files from `$DOTFILES_FOLDER` rather than sourcing directly from the repo checkout.
  4. `package.sh` reuses the same installer by changing `HOME` to a staging directory and setting `PACKAGING_START=true` so packaging skips the interactive dependency prompt.

- Most cross-platform logic lives in `functions`.
  - `get_os`, `get_arch`, and `is_termux` decide platform branches.
  - `manual_install`, `install_font_zip`, and `run_install_script` are the reusable installation primitives used by `install.sh`.

- The repo has three main user-facing config surfaces after installation:
  - shell startup: `SHELLS/BASH/bashrc`, `SHELLS/ZSH/zshrc`
  - terminal multiplexer: `tmux.conf`
  - editor: `vimrc`

## Key conventions

- Treat the top-level `aliases`, `exports`, and `functions` files as the shared source of truth for shell behavior. The Bash and Zsh rc files are mostly loaders plus shell-specific setup; avoid duplicating shared logic in both rc files.

- Reuse the helper functions in `functions` for any new installer work instead of open-coding downloads or platform detection. New OS branching should follow the existing `is_termux` / `OSTYPE == darwin*` / Debian-family pattern already used in `install.sh`.

- Automation should preserve the current `PACKAGING_START` behavior. That flag is the established way to make `install.sh` non-interactive during packaging/CI-style flows.

- Manual binary installs are expected to land in `$HOME/.local/bin`, while repo-managed shared config is expected in `$HOME/.config/dotfiles`.

- Changes to shell startup should account for both Bash and Zsh consumers:
  - Bash enables completions and evaluates `fzf --bash`.
  - Zsh is built around Oh My Zsh, loads a plugin list, auto-starts tmux, and evaluates `fzf --zsh`.

- `tmux.conf` and `vimrc` are opinionated and user-facing. Preserve existing keybinding choices unless the change explicitly updates the user experience:
  - tmux prefix is `Ctrl-Space`, not the default `Ctrl-B`
  - Vim uses `vim-plug`, `coc.nvim`, `ale`, and custom popup-terminal helpers

- Be careful with validation commands: `install.sh` modifies the real home directory, clones plugins, downloads assets, and changes the default shell with `chsh`. Prefer syntax checks first, then run installer/package flows only in disposable environments.
