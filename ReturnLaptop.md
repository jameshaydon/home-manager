# Returning This Laptop

Initial audit: 2026-07-12
Updated: 2026-08-15

## Summary

The core command-line environment is in good shape: this Home Manager repository
already declares the shell, Git configuration, most everyday command-line tools,
Obsidian, and iTerm2, with its Nix inputs pinned in `flake.lock`.

The Homebrew inventory, application reinstall list, and relevant macOS, iTerm2,
Maccy, Dock, input-source, keyboard-shortcut, and font preferences are now
captured in this repository, committed as `4d8d393`, and pushed to `origin/main`.
The remaining reproducibility gaps are:

1. Codex, Claude, Gemini, and Pi configuration is only partly tracked.
2. Credentials need a deliberate secure migration or re-authentication plan.
3. Protected macOS permissions and the captured environment still need to be
   restored and verified on the replacement Mac.

The `~/dev` review is complete. Retained personal repositories and worktree
branches were committed, pushed, and checked against live GitHub refs; loose
files, third-party checkouts, local-only branches, and generated output were
also reviewed and either dealt with or explicitly accepted as disposable.
Nothing under `~/dev` needs to be copied before wiping this laptop.

The Desktop, Downloads, development tree, and Google Drive synchronization are
complete. The only remaining local data to preserve is `~/Pictures`, principally
the Photos library. Durable configuration and credentials still need to be
preserved and verified as applicable.

Current retention decisions are:

- use Google Drive as the primary data and configuration destination;
- preserve personally owned Git repositories by committing and pushing wanted
  work, rather than copying all of `~/dev`;
- do not preserve any SpecForge worktree or anything under `~/dev/imiron-io`;
- preserve `~/Pictures`; other local data folders, including `~/media`, are
  explicitly disposable;
- use Firefox Sync for browser migration; do not prepare Chrome profile backups;
- do not preserve Docker or Signal state.

## Already reproducible

### Home Manager

The repository is on `main`, and its current commit matches its locally recorded
`origin/main`, but the working tree is not clean. `AGENTS.md`, `README.md`,
`flake.lock`, `flake.nix`, and `home.nix` are modified. The untracked entries
include `.claude/`, `GOTREE_WORKFLOW_RESEARCH.md`, and the `result` build symlink.
Review and commit the intended configuration and documentation, then push the
repository before erasing the laptop.

`flake.lock` pins nixpkgs, Home Manager, Emacs LSP Booster, Google Workspace CLI,
and the Claude, Codex, and Pi ACP integrations. `home.nix` declares:

- zsh, bash, Oh My Zsh, completion, autosuggestions, fzf, and zoxide;
- direnv and nix-direnv;
- Git identity and defaults, Delta, rerere, and global ignore rules;
- the main everyday command-line and AI tools;
- Google Cloud SDK, rclone, Cachix, and Emacs LSP Booster;
- Obsidian and iTerm2.

This configuration assumes an Apple Silicon Mac, the username `james`, and the
home directory `/Users/james`.

### Doom configuration

`~/.doom.d` is backed by `github.com/jameshaydon/.doom.d.git`. It tracks the Doom
modules, packages, settings, custom Lisp, and documentation needed to reconstruct
the personal Emacs configuration. On 2026-08-15, the reviewed changes were
committed as `478995b` and pushed; the clean local `master` and live
`origin/master` refs match that commit.

### Personal agent skills

`~/.agents` is backed by `github.com/jameshaydon/.agents.git`. It tracks the
personal skills and their source metadata. There are no personal skills directly
under `~/.codex/skills`; that directory currently contains Codex-managed system
skills. On 2026-08-15, the reviewed skill changes were committed as `a9cad97`
and pushed; the clean local `main` and live `origin/main` refs match that commit.

## Gaps and recommended changes

### 1. Homebrew

**Capture status: complete, committed as `4d8d393`, and pushed.** `Brewfile`
records the live Homebrew inventory verified on 2026-08-15. The explicitly
installed formulae are:

- `cmake`
- `gcc`
- `ghostscript`
- `libvterm`
- `patat`
- `zola`

The casks are:

- `codex`
- `emacs-app`
- `font-iosevka`
- `handy`
- `maccy`
- `vlc`

The only additional tap is:

- `jimeh/emacs-builds`

It supplies the current `emacs-app` installation; that specific cask is trusted
without trusting the entire third-party tap.

Restore them with `brew bundle --file ./Brewfile`. The current configuration uses
the smaller Brewfile approach; nix-darwin remains a possible later replacement
if system-level Nix and macOS defaults are brought under one configuration.

### 2. Applications

Home Manager already installs Obsidian and iTerm2. Homebrew covers Emacs, Handy,
Maccy, VLC, Codex, and the Iosevka font.

After reinstalling Handy, launch it once and grant Microphone and Accessibility
access. Back up `~/Library/Application Support/com.pais.handy` if its settings
and transcription history should move to the new Mac; downloaded speech models
can be recreated instead.

`REINSTALL.md` now records the complete terse reinstall checklist, including
lower-priority applications and the first-launch permissions or sign-ins that
need attention. Preserve only wanted durable settings and licences. Docker and
Signal state are explicitly disposable, and Chrome profile data is not part of
the migration.

### 3. Doom Emacs

**Git synchronization status: complete.** The configuration and documentation
changes were reviewed, committed as `478995b`, pushed, and verified against the
live `origin/master` ref on 2026-08-15.

Install the latest Doom Emacs on the new Mac rather than preserving the current
`~/.emacs.d` revision, then run `doom sync` with the tracked configuration.

The Lilo mode integration expects Specforge to be cloned at
`~/dev/imiron-io/specforge`. This is an intentional optional integration.

### 4. Codex and other agent configuration

`~/.codex` is not version-controlled and mixes durable preferences with roughly
2 GB of generated and sensitive state.

The durable Codex files are:

- `~/.codex/AGENTS.md`
- `~/.codex/config.toml`
- `~/.codex/rules/default.rules`

The useful parts of `config.toml` include the model defaults, features, TUI
theme and keymaps, plugin enablement, desktop preferences, and privacy/history
settings. The same file also contains brittle absolute paths, app-version hashes,
cache locations, timestamps, and project trust entries.

Do not commit the whole `~/.codex` directory. Instead, manage the stable files
or stable fragments through Home Manager. Leave authentication, histories,
sessions, SQLite databases, logs, caches, installation IDs, and downloaded
plugins outside Git. If histories or memories need to move, include them in an
encrypted backup.

Other durable machine-local preferences worth managing are:

- `~/.claude/settings.json`
- `~/.claude/keybindings.json`
- Claude plugin installation metadata
- `~/.gemini/settings.json`
- `~/.pi/agent/settings.json`
- `~/.pi/agent/keybindings.json`
- `~/.aider.conf.yml`

`~/.agents` is clean and synchronized at `a9cad97`. The updated and newly added
personal skills, including `close-out-pr`, `create-pr`, the SpecForge release
skills, `prune-worktrees`, and `wt-status`, were pushed and verified against the
live `origin/main` ref on 2026-08-15.

### Browser migration

Firefox is the migration target. Its active `default-release` profile is signed
in to a verified Mozilla account. The profile recorded a sync at 10:55 JST on
2026-08-14. The most recent detailed sync log completed successfully with zero
failed records for passwords, bookmarks, add-ons, history, open tabs, settings,
addresses, payment methods, and extension storage. Older error entries were
temporary DNS failures and recovered successfully.

Before erasing, open Firefox, use **Settings -> Sync -> Sync now**, and confirm
that Sync remains enabled for every desired data category. Then sign in on the
replacement device and verify representative bookmarks, passwords, history,
add-ons, and settings. Mozilla documents the synchronized categories in
[Sync Firefox data](https://support.mozilla.org/en-US/kb/sync).

The two other local Firefox profiles are not signed in and appear to be unused
or secondary. Chrome profile migration is intentionally out of scope.

### 5. macOS and application preferences

**Capture status: complete.** `macos/defaults.sh` records the stable macOS and
Maccy defaults, `macos/README.md` records the manual application and protected
settings, and `macos/symbolic-hotkeys.json` preserves the opaque keyboard
shortcut value for comparison. Notable machine-local choices include:

- keyboard repeat values `InitialKeyRepeat=15` and `KeyRepeat=2`;
- Dock auto-hide and tile size 68;
- Finder path bar and status bar enabled;
- customized global keyboard shortcuts;
- the ABC keyboard layout;
- iTerm2 using Iosevka Term at size 13;
- Maccy popup shortcut, window size, and visible UI elements.

The script intentionally does not import private input-source preferences,
serialized Dock bookmarks, or symbolic shortcut IDs. These are captured as a
manual checklist because their representation is brittle across macOS releases.

Accessibility access, Full Disk Access, notifications, VPN permissions, browser
sync, Dock contents, and similar protected settings should be a manual checklist.

### 6. Fonts

Iosevka is covered by Homebrew. These user-installed fonts are not tracked:

- `NFM.ttf`
- `NotoSansJP-VariableFont_wght.ttf`

Prefer a Nix or Homebrew font package where available. Otherwise place the font
files in a private backup and declare their installation through Home Manager.

### 7. Credentials

Credentials should be re-created or transferred securely, never committed to
this repository. Relevant state includes:

- the SSH private key and `~/.ssh/config`;
- API keys currently stored as top-level dotfiles;
- Codex, Claude, Gemini, and Pi authentication;
- GitHub CLI, Google Cloud, Google Workspace CLI, and rclone credentials;
- the Specforge licence and `.pypirc`.

GitHub CLI authentication was working on 2026-08-14. Expect to authenticate it
again on the replacement machine rather than copying its opaque token state.

The API-key files and `.pypirc` currently have `0644` permissions. Change them
to `0600`, or preferably move secrets into the macOS Keychain, a password
manager, or an encrypted age/sops-managed store.

Opaque application token databases should normally not be copied. Re-authenticate
on the new machine unless a service has no practical recovery path.

## Data migration plan

### Google Drive state

**Synchronization status: complete.** Google Drive for desktop is active for
the personal account. `~/tuvok` and every other retained folder report fully
synced.

Before erasing, verify that the retained folders are visible under **Computers**
at drive.google.com and restore representative files successfully.

### Desktop

**Status: complete.** The Desktop has been fully reviewed. Wanted files were
preserved and verified, and everything else is explicitly accepted as
disposable. Nothing under `~/Desktop` needs further migration work before the
laptop is erased.

As of 2026-08-15, `~/Desktop` occupies about 126 MiB and contains 226 regular
non-metadata files. This total includes 89 files under `Important Documents -
Not in Google Drive` and duplicate source copies of files added there during this
audit. The former large `stlbound_aristotle`, `atode`, and `Codex.dmg`
entries are no longer present. `elisa-subs` was deliberately deleted.

The following personal records were copied into `Important Documents - Not in
Google Drive` and byte-verified against their source files:

- `mina-in-japan.tif`;
- `2025-11-19 cleanup/DSCF8096.jpg`;
- `2025-11-19 cleanup/japan.org`, which is newer and differs from the version in
  personal Drive;
- the two `2025-11-19 cleanup/Screenshot 2025-06-28 ...` Passport Office images.

An exact-content comparison found personal Drive copies of the Desktop CV,
three employment letters or certificates, the old Japan passport package, the
Shinsei statement CSV, `2025-11-19 cleanup/index.html`, and the old SSH keypair.
The two files inside the old shipment ZIP are also byte-identical to the receipt
and label already in the preservation folder. `new-flat.md` has been deliberately
distilled into `tuvok/wiki/Resources/japan-flat-application-notes.md` in Drive.

Do not preserve `Brief_general.docx`, `Brief_tech.docx`, or the AI-governance
research (`NeuroMagix_Competitive_Analysis.docx`, `Competitive Landscape for
Deterministic AI-Agent Governance Layers.docx`, `Policy as code- Enforcement for
Agentic Systems.md`, `competitors.md`, and `demo_ver2.html`).

The remaining small source and design items were reviewed and are explicitly not
being retained. These include `Expand.hs`, `curvature-question.excalidraw`,
`hermit-crabs`, `nextlang`, `weft.png`, `ball.svg`, `avatar.png`, the Lilo
documentation screenshot, and the three SpecForge tutorial JSON files.

`ArtificialLabsTechDD - FINAL.pdf`, all 27 files in the `amazon` policy folder,
`docs/Amazon Visual Aid- JP Outbound Briefing Deck.pdf`, and `docs/AGS IMPORT
COUNTRY GUIDE UNITED KINGDOM_2023_v1.pdf` were copied into the employment or
relocation sections of the preservation folder and byte-verified. Employer,
client, or work-derived material explicitly not being retained includes
`docs/Guide to completing HMRC forms.pdf`, the two `datalab-output-...html`
files, the long-named process-diagram PNG, and `task_component.proto`. Do not
copy these.

Do not put `2025-11-19 cleanup/dotfiles` or `ptor` into ordinary Drive storage:
they contain plaintext credentials. The old SSH private key already has an exact
unencrypted copy in personal Drive; rotate and remove it if it is still active.

### Other standard folders

Only `~/Pictures` is being retained. The other local data folders in this table
are explicitly disposable:

| Folder | Approximate size | What occupies it | Plan |
| --- | ---: | --- | --- |
| `~/Documents` | 15 MiB | MATLAB example and generated-code material | Disposable; no copy required. |
| `~/Downloads` | negligible | Only `.DS_Store` and `.localized` remain | Complete; wanted files were preserved in Google Drive and the remainder was deleted. |
| `~/Pictures` | 2.0 GiB | Almost entirely `Photos Library.photoslibrary` | Quit Photos, preserve the complete library package, and test opening the restored copy. |
| `~/Movies` | 1.3 GiB | One video in the TV library | Disposable; no copy required. |
| `~/Music` | less than 1 MiB | Music library databases; no substantial media | Disposable; no copy required. |
| `~/Public` | 627 MiB | One television episode | Disposable; no copy required. |
| `~/marvin` | 2.6 MiB | A personal Git repository containing notes, meeting material, scripts, and job-preparation content | Complete; commit `37edf15` was pushed to `jameshaydon/marvin`, matched the live `main` ref, and left the worktree clean. |

The `~/Downloads` review is complete and needs no further migration work.

### Development tree: complete

The complete `~/dev` tree was reviewed on 2026-08-15 and is cleared for erasure
with the laptop. Do not copy the directory wholesale, and do not perform any
additional migration work there.

Retained work was committed, pushed, and verified against live GitHub refs. This
included `goldilocks`, `llm`, `senti`, `jamessite` (`jameshaydon/mysite`),
`sentinel`, `uk-portion-of-ICAO`, and the `weft` `main`, `javascript-target`, and
`power-expect` branches. The private `jameshaydon/SACat` fork received the full
local `master` history and the three tags present in the organization
repository. Existing retained repositories with no wanted work were also
checked against their live remotes.

The rest of `~/dev` was explicitly reviewed and dealt with. This included loose
documents and non-repository directories, research notes inside third-party
checkouts, non-owned organization repositories, old local-only branches,
`pyth`, and projects deliberately not retained. The modified `after-dark-0`
checkout duplicated content already present in the pushed personal fork.

Remaining local-only entries are accepted as disposable: agent-setting links,
`.DS_Store`, rendered documents, downloaded models, training/build output,
virtual environments, and other regenerable state such as `.direnv`,
`dist-newstyle`, `.stack-work`, `.lake`, `node_modules`, `target`, `.venv`, and
`venv`. The standing decision not to preserve any SpecForge worktree or anything
under `~/dev/imiron-io` remains in force.

### Physical media

**Status: disposable.** Nothing under `~/media` (about 202 GiB) needs to be
preserved. No physical-disk copy is required before erasing the laptop.

### Durable configuration and credentials

Preserve the small durable configuration identified elsewhere in this document,
including selected Codex/Claude/Gemini/Pi settings and histories, VS Code user
settings, iTerm2 and Maccy preferences, fonts, shell histories, SSH configuration,
and CLI credentials. Store API keys, SSH private keys, `.pypirc`, and other
secrets only in an encrypted archive or password manager, never as plaintext in
Google Drive.

## Intentionally disposable state

Future audits should not spend time preserving these items unless this section
is explicitly revised:

- all Docker containers, images, volumes, configuration, and Docker Desktop
  state;
- all Signal Desktop history and configuration; reinstall and relink instead;
- all SpecForge repositories and worktrees;
- everything under `~/dev/imiron-io`;
- generated development output: `.direnv`, `dist-newstyle`, `.stack-work`,
  `.lake`, `node_modules`, `target`, `.venv`, and `venv`;
- the roughly 23 GiB Cabal build state under `~/.local/state/cabal`;
- the current `~/.emacs.d` checkout and generated state; reinstall Doom Emacs
  and run `doom sync` using the preserved `~/.doom.d` configuration;
- downloaded application caches, installers, and reproducible speech models;
- `~/Documents`, `~/Movies`, `~/Music`, `~/Public`, and `~/media`;
- Chrome profile data, because Firefox Sync is the chosen browser migration
  mechanism.

## Recommended order of work

1. Review, commit, push, and fresh-clone the Home Manager repository. **Complete
   for Doom and personal agents:** both repositories are clean, pushed, and
   verified against their live remote refs.
2. **Complete:** `~/dev` has been fully reviewed; retained work was pushed and
   live-verified, and the remainder was explicitly dealt with or accepted as
   disposable.
3. **Complete:** `~/Desktop` and `~/Downloads` have been fully reviewed and
   dealt with, and every retained Google Drive folder reports fully synced.
4. Verify retained Google Drive folders and representative restored files;
   preserve `~/Pictures`, then open the restored Photos library successfully.
5. Preserve durable application and agent configuration, with credentials in an
   encrypted archive or password manager.
6. Open Firefox, run **Sync now**, and verify the restored account on another
   device.
7. **Complete, committed as `4d8d393`, and pushed:** the Brewfile and application
   reinstall list are recorded, and stable macOS/Maccy defaults plus manual
   iTerm2, input-source, Dock, protected permission, and font settings are
   captured.
8. Restore and test representative data and configuration on the replacement
   Mac before returning or erasing this one.

## Completion criterion

Do not factory-reset the laptop until every applicable item below is complete:

- [x] `~/dev` is fully reviewed and safe to erase; retained Git work was pushed
      and verified by remote inspection, and all other contents were dealt with.
- [x] `~/Desktop` and `~/Downloads` are fully reviewed and safe to erase.
- [x] Retained personal Git work outside `~/dev`, including `~/marvin`, is
      committed, pushed, and verified by a fresh clone or remote inspection.
- [x] Doom and personal agent configuration is committed, pushed, and verified
      against the live remote refs.
- [x] The Homebrew inventory, application reinstall list, and relevant macOS and
      application preferences are captured, committed as `4d8d393`, and pushed.
- [ ] Home Manager configuration is committed and pushed.
- [x] Google Drive reports no pending work and every retained folder is fully
      synced.
- [ ] Retained Google Drive folders are visible under **Computers**, and
      representative files have been restored successfully.
- [x] All local data apart from `~/Pictures`, including `~/media`, is explicitly
      disposable and requires no migration.
- [ ] The Photos library opens from its restored copy.
- [ ] Firefox has completed a final **Sync now**, and the replacement device
      shows bookmarks, passwords, history, add-ons, and settings.
- [ ] Encrypted credentials and durable local application configuration have
      been restored or their re-authentication path has been tested.
- [ ] The replacement Mac can reproduce the shell, Git, Emacs, agent, and
      desktop environment from the preserved configuration.

Only after these checks pass should accounts and licensed applications be signed
out and **Erase All Content and Settings** be used.
