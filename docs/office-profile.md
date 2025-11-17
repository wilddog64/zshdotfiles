# Office / WSL Profile Guide

The `office` profile reintroduces Costco-specific settings (WSL paths, office aliases, Windows wrappers) while keeping the default configs portable. Follow these steps to enable it on your workstation.

## 1. Prepare the Office Directory

```sh
mkdir -p ~/.zsh/office
cp ~/.zsh/office/zshenv.example ~/.zsh/office/zshenv
cp ~/.zsh/office/zshrc.example ~/.zsh/office/zshrc
cp ~/.zsh/office/aliases.example ~/.zsh/office/aliases
cp ~/.zsh/office/cdnames.example ~/.zsh/office/cdnames
cp ~/.zsh/office/bashrc.example ~/.zsh/office/bashrc
```

These copies stay untracked because `.gitignore` excludes the real files. Update them with internal hosts/secrets as needed.

## 2. Enable the Profile

The office snippets load automatically when the files above exist. You can also force the mode explicitly:

```sh
export ZSH_PROFILE=office
```

Add that to your terminal profile (`~/.zprofile`) if you regularly switch hosts.

## 3. Windows / WSL Helpers

All Windows bridge scripts now live under `~/.zsh/office/win`. Point your existing `~/bin` symlink at that directory so wrappers like `win32yank` remain on `PATH`:

```sh
ln -sfn ~/.zsh/office/win ~/bin
```

## 4. Cross-Platform Scripts

Shared helper scripts belong under `~/.zsh/scripts/`. The repo provides `sync-local-bin` to mirror them into `~/.local/bin` without mixing office-specific content:

```sh
~/.zsh/scripts/sync-local-bin
```

`zshrc` now runs this helper automatically once each shell via a `precmd` hook, so any executable you drop in `scripts/` appears on `PATH` immediately.

## 5. Additional Notes

- Keep secrets out of git by editing only the copies inside `~/.zsh/office/`.
- If you add new office-only files, create an `.example` version under `office/` and ignore the real path so others can follow along safely.
- Document new requirements (VPNs, internal package feeds, etc.) alongside the `.example` files for easier onboarding.
