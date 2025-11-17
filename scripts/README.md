# Local Scripts

Place cross-platform helper scripts in this directory and create a symlink to expose them on your PATH. A typical setup links everything into `~/.local/bin`:

```sh
mkdir -p ~/.local/bin
ln -s ~/.zsh/scripts/* ~/.local/bin/
```

Keep Windows-only wrappers in `office/win/` (symlink that folder to `~/bin`). This split keeps office tooling optional while letting the shared repo host portable utilities.
