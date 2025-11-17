# Office Profile Audit

Snapshot of Costco/WSL-specific content that should move behind the future opt-in profile.

## Core Shell Configs

- `zshenv:4-232`  
  - Hard-codes Linuxbrew paths (`/home/linuxbrew/.linuxbrew`) and duplicates `/usr/local` Homebrew exports.  
  - Adds office tooling PATH entries (`/opt/puppetlabs`, `/opt/omi`, OpenJDK tap) and exports for Puppet, OMI, dotnet, postgres, OpenSSL, GNU tar, etc.  
  - Sets company-specific variables like `VAULT_ADDR`, `FORGIT_INSTALL_DIR`, PHPBREW/PHP flags, HOMEBREW tokens, and Ruby build options.  
  - Enables aggressive `setopt` history/completion knobs that may not be desired globally.  
  - Defines WSL/Windows bridge variables (`WINHOME`, `WINAPPS`, chocolatey, Cmder) and rewrites `PATH` to include Windows tools, `wslview`, `LPASS`, etc.

- `zshrc:119-270`  
  - SSH keychain logic assumes RSA key on Linux vs. Ed25519 on mac.  
  - Loads hub aliasing, perlbrew, macOS `java_home`, Homebrew-managed `nvm`, Puppet PDK, goenv, direnv, antigen, smartcd, zplug bootstrap, Tilix/VTE shims.  
  - Hooks numerous dev-tool completions (gh, yq, eksctl, chef, kubectl) and WSL helpers (`fix_wsl_process`).  
  - These should only run when the office toolchain is installed; main branch likely wants leaner defaults.

- `bashrc:12-176`  
  - WSL-specific aliases for `xsel`, `minikube`, and `kubectl` pointing to `/mnt/c`.  
  - Forces `nvim.appimage` path and references `/root/src/...` which only exists on the office workstation.  
  - Duplicates bash-it bootstrapping with paths under `/home/cliang/.bash-it`.

- `aliases:35-50`  
  - Costco authentication helpers (`duoauth`, `awssamlapi` profiles).  
  - Office tool overrides (`vi=/home/linuxbrew/...`, `docker=podman`, `eyaml` path, `uuidcdef`, lazygit, git helpers) that may not apply elsewhere.

## Scripts & Utilities

- Root-level helpers (`run.sh`, `cleanup_pv_pvc.sh`, `get-services`, `kgc.sh`, `find_aws_vpc_deps.sh`, `large_file.sh`, `tmx`, `vault_encrypt.sh`, `yank.sh`, etc.) mix generic tools with Costco expectations (kubectl usage, Podman images, internal Jenkins/CMDB env vars). Each needs classification before exposing to base users or moving under `office/`.
- `argocd/argocd_app.yaml`, `k8s-template/*`, `smartcd_costco_template`, `services-output`, `samlapi.ini`, `krb5.conf`, and `my-proxy.crt` embed internal hostnames and credentials—good candidates for the office namespace or removal.

## Windows Bridge (`win/`)

- Entire `win/` directory contains wrappers that shell out to Windows binaries (`alacritty`, `cmd`, `regedit`, Sysinternals tools, tkgi scripts, etc.) plus Clink `inputrc` files. These only make sense inside WSL on the Costco-issued machine and should move under the office profile (or be guarded by a WSL check).

## Next Actions Derived from Audit

1. Extract the identified sections into `office/` snippets (e.g., `office.zshenv`, `office.aliases`, `office/bin/*`).  
2. Replace the original locations with guards (`if [[ -f ~/.zsh/office.zshenv ]] ...`) so base configs stay portable.  
3. Provide `.example` templates for sensitive files and update documentation per the plan in `docs/plans/office-profile.md`.
