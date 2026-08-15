# Repository Guidelines

This repository is James's personal Home Manager configuration for a local
macOS machine. Treat changes here as machine-affecting configuration, not as an
ordinary application repo.

## Scope and Structure

- `flake.nix` defines the Home Manager flake for `homeConfigurations."james"` on
  `aarch64-darwin`.
- `home.nix` contains the main user configuration: packages, shell setup,
  aliases/functions, session variables, dotfiles, and Git settings.
- `flake.lock` is committed and should only change when flake inputs are
  intentionally updated.
- `README.md` is minimal.
- `result` is a local Nix build symlink and should not be edited or committed.
- `.claude/` contains local agent settings and is currently untracked; do not
  assume it should be committed.

## Working Rules

- Check `git status --short` before editing. This repo often has active local
  changes; do not revert, reformat, or overwrite changes you did not make.
- Keep edits narrowly scoped. A mistake can affect the user's shell, PATH, Git
  defaults, installed packages, or activated Home Manager generation.
- Do not expose or inline secrets. `home.nix` loads API keys from files in
  `$HOME`; preserve that pattern.
- Prefer explicit package pins or flake inputs for nonstandard software. If an
  input changes, expect `flake.lock` to change as part of the same intent.
- Keep Nix code readable and consistent with the existing style. Avoid broad
  rewrites unless the user specifically asks for cleanup.

## Validation

Use a non-activating build before suggesting activation:

```sh
nix build --no-link .#homeConfigurations.james.activationPackage
```

For full activation, use:

```sh
home-manager switch --flake .#james
```

Only run activation when the user asked for it or when it is clearly necessary
and safe to apply the local-machine config.

## Notes for Common Changes

- Package additions usually belong in `home.packages` in `home.nix`; flake
  inputs are only needed when the package is not available from the selected
  `nixpkgs` or requires an overlay.
- Shell behavior lives under `programs.zsh`, especially `profileExtra`,
  `shellAliases`, `oh-my-zsh`, and `initContent`.
- Git defaults live under `programs.git`; changes there affect every repo on the
  machine.
- Worktrunk is installed and shell-integrated in `home.nix`. The
  `wt-link-primary` helper lets project-local Worktrunk hooks safely share
  canonical files and missing agent-config entries without replacing tracked
  paths.
