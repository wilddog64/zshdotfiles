# Office/WSL Profile Plan

Goal: keep the main shell configuration portable while allowing an opt-in Costco office/WSL profile that reintroduces the current branch customizations.

## 1. Audit Office-Specific Content
- Review `zshenv`, `zshrc`, `bashrc`, `aliases`, helper scripts, and `win/` wrappers to label which lines depend on Costco infrastructure, `/mnt/c` tooling, or other office secrets.
- Note scripts and configs that are already cross-platform and can remain in the base repo.
- Record any sensitive values currently hard-coded (e.g., Jenkins/CMDB endpoints, tokens) and plan to move them to ignored files.

## 2. Define Opt-In Mechanism & Layout
- Choose a trigger (e.g., `ZSH_PROFILE=office`, `HOST_ENV=office`, or existence of `~/.zsh/office.zsh`).
- Create an `office/` directory that contains:
  - `office.zshenv` / `office.zshrc` snippets (with `.example` templates committed, real files ignored).
  - Office-only aliases, functions, PATH exports, and Windows bridge scripts.
  - Documentation for required secrets and how to obtain them.
- Decide how to package helper scripts (e.g., keep them in `office/bin` or similar) and how main configs reference them.
  - Windows bridge wrappers now live under `office/win/`; keep a symlink to `~/bin` when the office profile is enabled.
  - Cross-platform helpers should move into `scripts/` so they can be symlinked into `~/.local/bin` without pulling in office dependencies.

## 3. Refactor & Document
- Move office-specific blocks from the core configs into the new office snippets; replace them with guarded `if [[ -f ~/.zsh/office.zshrc ]]` style includes.
- Split aliases/bashrc content into base vs. office-specific files, sourcing the latter only when the opt-in flag/file is present.
- Relocate helper scripts (`run.sh`, `cleanup_pv_pvc.sh`, `get-services`, `win/*`, etc.) under the office namespace or wrap their sourcing in the new guard.
- Create `.example` files for any sensitive env vars (e.g., `.office.env.example`) and update `.gitignore` accordingly.
- Update `README.md` (or add `docs/office.md`) explaining how to enable the office profile, where to place secrets, and any dependencies (Podman, Azure PowerShell, kubectl, etc.).

## 4. Merge Strategy
- Once the opt-in structure is in place, rebase/merge this branch onto `main` to ensure base configs remain unchanged for non-office users.
- Provide instructions for office users to copy the example files, set the profile flag, and verify the conditional logic (zplug, completions, scripts).
