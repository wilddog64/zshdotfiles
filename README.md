# ZSH Configuration Files

A comprehensive ZSH shell configuration setup with various plugins, completions, and utilities.

## Structure

```
.zsh/
├── aliases           # Shell aliases
├── bindingkeys       # Key binding configurations
├── cdnames          # Directory shortcuts
├── comp_styles      # Completion styling
├── fzf-shell/       # Fuzzy finder integration
├── functions/       # Custom shell functions
├── hal_completion   # HAL command completions
├── kgc.sh          # Kubernetes container utilities
├── my_func.zsh     # Personal shell functions
├── office/         # Office-only overlays (see docs/plans)
├── scripts/        # Cross-platform helper scripts
└── zplugs.zsh      # Plugin configurations
```

## Features

- Fuzzy finding (fzf) integration
- Git integration with hub
- Multiple version managers (pyenv, rbenv, nvm, goenv)
- Kubernetes tools integration
- Docker support
- Advanced key bindings
- Directory jumping (autojump)
- Smart directory handling (smartcd)
- Package management via zplug
- Custom completion styles
- iTerm2 integration

## Prerequisites

- Zsh
- Homebrew
- Git
- fzf
- Various development tools (optional):
  - pyenv
  - rbenv
  - nvm
  - goenv
  - docker
  - kubernetes tools

## Installation

1. Clone this repository:
```bash
git clone <repository-url> ~/.zsh
```

2. Create symlinks:
```bash
ln -s ~/.zsh/zshrc ~/.zshrc
ln -s ~/.zsh/zshenv ~/.zshenv
```

3. Install required tools:
```bash
brew install fzf zplug autojump direnv
```

## Key Components

- **Aliases**: Common shortcuts and command aliases
- **Key Bindings**: Custom key mappings for efficient shell navigation
- **Completions**: Enhanced tab completion for various tools
- **Functions**: Utility functions for common tasks
- **Plugin Management**: Using zplug for plugin management
- **Development Tools**: Integration with various development environments

## Plugin Management

This configuration uses zplug for plugin management. Plugins are defined in `zplugs.zsh`.

## Environment Management

- Supports multiple language version managers
- Integrated with direnv for project-specific environments
- Configurable through environment variables

## Customization

1. Add custom aliases to `aliases`
2. Add custom functions to `my_func.zsh`
3. Modify key bindings in `bindingkeys`
4. Add directory shortcuts to `cdnames`
5. Manage helper binaries via `scripts/README.md`

## Helper Scripts

Portable utilities live under `scripts/`. Run `~/.zsh/scripts/sync-local-bin` to populate `~/.local/bin` (or set `LOCAL_BIN_DIR`) with symlinks to every executable in that directory. See [`scripts/README.md`](scripts/README.md) for details.

## Performance

The configuration includes performance optimizations:
- Lazy loading of certain components
- Conditional loading based on available tools
- Plugin management for efficient loading

## Troubleshooting

If you encounter slow shell startup:
1. Enable zsh profiling:
```bash
zmodload zsh/zprof
```
2. Start a new shell
3. Run `zprof` to see timing details

## License

[Your License Here]

## Contributing

Feel free to submit issues and pull requests.
