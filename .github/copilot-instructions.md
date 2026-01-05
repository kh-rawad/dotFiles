# Copilot Instructions for DotFiles Repository

## Architecture Overview
This is a modular dotfiles management system with cross-platform support, organized around:
- **Core config files**: `aliases`, `exports`, `functions`, `abbreviations` (sourced by shells)
- **Shell configurations**: `SHELLS/BASH/bashrc` and `SHELLS/ZSH/zshrc` (both source core files)
- **Installation system**: `install.sh` (main installer), `package.sh` (offline packaging), `setEnv` (environment detection)
- **Task automation**: `Taskfile.yml` (TaskFile.dev integration)
- **Application configs**: tmux, vim configurations

## Key Workflows

### Installation Process
- **Primary**: `./install.sh` - Detects OS via `setEnv`, copies configs, installs dependencies
- **Offline**: `./package.sh` - Creates tarball package for air-gapped systems
- **Environment**: `setEnv` sources `functions` and exports `SYSTEM_INFO="$(get_os)-$(get_arch)"`

### Task Management
- Uses [TaskFile.dev](https://taskfile.dev) (`task` command) - see `Taskfile.yml`
- Install instructions in `APPS/go.task` for different package managers

## Project-Specific Patterns

### Modular Shell Configuration
Both bashrc and zshrc follow the pattern:
```bash
DOTFILES_FOLDER="$HOME/.config/dotfiles"
source "$DOTFILES_FOLDER/aliases"
source "$DOTFILES_FOLDER/exports" 
source "$DOTFILES_FOLDER/functions"
```

### Cross-Platform Detection
- `setEnv` + `functions` provide OS/architecture detection via `get_os()` and `get_arch()`
- Install scripts branch on `$OSTYPE` (Darwin/macOS) and `/etc/*release` (Debian/Ubuntu)
- Package managers: `brew` (macOS), `apt` (Debian/Ubuntu)

### Custom Utilities in `functions`
- `extract()` - Universal archive extractor supporting 10+ formats
- `vimod()` - Opens all git-modified files in vim tabs
- `manual_install()` - Downloads and installs binary releases from GitHub
- `run_install_script()` - Clones repos and runs their install scripts
- `treee()` - Folder tree visualization using ls/grep/sed

### Tmux Configuration
- Custom prefix: `Ctrl+Space` (not default Ctrl+b)
- Vim-style pane navigation (`h/j/k/l`)
- Auto-create new windows/panes in current path
- Plugin manager: TPM with tmux-sensible and tmux-fzf

### Development Conventions
- Scripts use `#!/bin/bash` shebang consistently
- Environment variables prefixed with project context (`DOTFILES_FOLDER`, `PACKAGING_START`)
- Error handling pattern: `[[ $? -ne 0 ]] && echo "Failed..." && exit 1`
- Temporary directory cleanup in packaging scripts

## Key Integration Points
- **NVM integration**: Both shells auto-load Node Version Manager
- **History optimization**: 100k line history with duplicate removal
- **Terminal enhancement**: 256-color support, custom prompt themes
- **Package management**: Automated dependency installation per platform
- **Vim integration**: Custom abbreviations file, editor preference in exports

When modifying this codebase, maintain the modular sourcing pattern and cross-platform compatibility checks.