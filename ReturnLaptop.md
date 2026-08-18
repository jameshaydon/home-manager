# Returning This Laptop

Initial audit: 2026-07-12
Updated: 2026-08-18

## Summary

The core command-line environment is in good shape: this Home Manager repository
already declares the shell, Git configuration, most everyday command-line tools,
Obsidian, and iTerm2, with its Nix inputs pinned in `flake.lock`.

The Homebrew inventory, application reinstall list, and relevant macOS, iTerm2,
Maccy, Dock, input-source, keyboard-shortcut, and font preferences are now
captured in this repository, committed as `4d8d393`, and pushed to `origin/main`.
All pre-return preservation work that blocks erasure is complete. Protected
macOS permissions and reproduction of the captured environment must be verified
later, when the replacement Mac is available; those checks do not block
returning this laptop.

The `~/dev` review is complete. Retained personal repositories and worktree
branches were committed, pushed, and checked against live GitHub refs; loose
files, third-party checkouts, local-only branches, and generated output were
also reviewed and either dealt with or explicitly accepted as disposable.
Nothing under `~/dev` needs to be copied before wiping this laptop.

The Desktop, Downloads, development tree, Google Drive synchronization and
restore check, preservation of `~/Pictures`, durable Codex, Claude, Pi, and SSH
configuration, and encrypted shell histories are complete. The restored Photos
library has been opened and tested successfully.

Current retention decisions are:

- use Google Drive as the primary data and configuration destination;
- preserve personally owned Git repositories by committing and pushing wanted
  work, rather than copying all of `~/dev`;
- do not preserve any SpecForge worktree or anything under `~/dev/imiron-io`;
- preserve `~/Pictures`; other local data folders, including `~/media`, are
  explicitly disposable;
- use Firefox Sync for browser migration; do not prepare Chrome profile backups;
- do not preserve Python configuration, any API keys, the SpecForge licence,
  Gemini or Aider configuration, VS Code settings, Imiron-specific CLI state, or
  the two manually installed fonts;
- do not preserve Docker or Signal state.

## Remaining pre-return TODO

All pre-return tasks in this section are complete:

- [x] Preserve the stable Codex, Claude, and Pi configuration identified below.
- [x] Securely preserve `~/.zsh_history` and `~/.bash_history`.
- [x] Decide whether the SSH private key and configuration should move, then
      preserve them securely or explicitly accept them as disposable.

The curated configuration, restore notes, checksums, and encrypted history
archive are stored in personal Google Drive at
`My Drive/home/pre-return-2026-08-18`. The existing passphrase-protected SSH
private key remains at `My Drive/home/.ssh/id_ed25519`; it was not copied again.
No accounts have been signed out, and the laptop has not been erased.

## Already reproducible

### Home Manager

**Git synchronization status: complete.** The repository is on `main` at
`6d4f06a`, and that commit matches its locally recorded `origin/main`. The
intended Home Manager configuration and documentation changes have been reviewed,
committed, and pushed. The remaining untracked `.claude/` directory and `result`
build symlink are outside the completed Home Manager configuration sync.

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

### 4. Codex, Claude, and Pi configuration

**Status: complete.** Stable Codex, Claude, and Pi configuration is preserved in
personal Google Drive at `My Drive/home/pre-return-2026-08-18/agent-config`,
without authentication or generated state.

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

The preservation set contains exact copies of `AGENTS.md` and `default.rules`
plus a curated `config.toml` restore template containing only stable preferences.
Authentication, project trust entries, brittle paths, histories, sessions,
SQLite databases, logs, caches, installation IDs, generated MCP definitions,
and downloaded plugins were not copied.

Preserve these Claude files and record the enabled plugin identifiers without
copying generated plugin installation state:

- `~/.claude/settings.json`
- `~/.claude/keybindings.json`

Preserve these Pi files:

- `~/.pi/agent/settings.json`
- `~/.pi/agent/keybindings.json`

The Claude restore template omits trusted workspace paths but retains the
enabled plugin identifiers and the marketplace source needed by
`codex@openai-codex`. The Pi settings template omits the generated
`lastChangelogVersion`. `MANIFEST.sha256` was checked successfully against every
saved configuration file and the encrypted history archive on 2026-08-18.

Do not preserve Gemini or Aider configuration. Re-authenticate Codex, Claude,
and Pi on the replacement Mac instead of copying their token or authentication
files.

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

The final pre-erasure **Sync now** was completed on 2026-08-17. When the
replacement device is available, sign in to the Mozilla account and verify
representative bookmarks, passwords, history, add-ons, and settings. Mozilla
documents the synchronized categories in
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

**Status: complete; no migration TODO.** Iosevka, the only font being retained,
is covered by the `font-iosevka` cask in `Brewfile`. These other user-installed
fonts are explicitly disposable:

- `NFM.ttf`
- `NotoSansJP-VariableFont_wght.ttf`

### 7. Credentials

Do not preserve any API keys. The existing top-level files are:

- `~/.anthropic-api-key`
- `~/.openai-api-key`
- `~/.openrouter-api-key`
- `~/.gemini-api-key`
- `~/.aristotle-api-key`

Do not preserve the SpecForge licence or `.pypirc`. The latter contains only
commented notes for the old Imiron Python package repository, not active Python
package settings or credentials. No Python configuration needs to move.

Do not copy CLI authentication state. The GitHub CLI token is already invalid;
run `gh auth login -h github.com` on the replacement Mac. The Google Cloud and
Google Workspace CLI configurations point to the Imiron account and project,
and the only rclone remote is `gdrive-imiron:`; all are disposable.

**SSH decision: complete.** Retain the current `~/.ssh/id_ed25519` key for
migration, then rotate it after the replacement Mac is working. The private key
is passphrase-protected, its passphrase was tested successfully, and its public
key remains registered on GitHub. A byte-identical keypair was already present
at `My Drive/home/.ssh`, so no additional private-key copy was made. The current
SSH config is preserved at
`My Drive/home/pre-return-2026-08-18/agent-config/ssh/config`. The `known_hosts`
files are regenerable and were not preserved as part of this work.

## Data migration plan

### Google Drive state

**Synchronization status: complete.** Google Drive for desktop is active for
the personal account. `~/tuvok` and every other retained folder report fully
synced. The retained folders are visible under **Computers** at drive.google.com,
and representative files have been restored successfully.

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
Shinsei statement CSV, `2025-11-19 cleanup/index.html`, and the current
passphrase-protected SSH keypair.
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
they contain plaintext credentials. The current SSH private key already has an
exact passphrase-protected copy in personal Drive. Retain it for migration, then
rotate and remove it after the replacement Mac is working.

### Other standard folders

Only `~/Pictures` is being retained. The other local data folders in this table
are explicitly disposable:

| Folder | Approximate size | What occupies it | Plan |
| --- | ---: | --- | --- |
| `~/Documents` | 15 MiB | MATLAB example and generated-code material | Disposable; no copy required. |
| `~/Downloads` | negligible | Only `.DS_Store` and `.localized` remain | Complete; wanted files were preserved in Google Drive and the remainder was deleted. |
| `~/Pictures` | 2.0 GiB | Almost entirely `Photos Library.photoslibrary` | Preservation and restored-library opening verified. |
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

**Status: complete.** The stable Codex, Claude, Pi, and SSH configuration is in
`My Drive/home/pre-return-2026-08-18/agent-config`. The zsh and bash histories
are in `shell-histories-2026-08-18.tar.age` in the parent directory, encrypted
with `age` to the retained SSH key. The archive was decrypted using the
passphrase-protected private key, and both histories matched their recorded
SHA-256 checksums. The two older plaintext history files were removed from
`My Drive/home` and moved to recoverable Google Drive Trash.

Do not preserve Python or VS Code configuration, Gemini or Aider configuration,
API keys, the SpecForge licence, `.pypirc`, agent authentication databases,
Imiron CLI credentials, or the two untracked fonts.

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
- all API-key files, the SpecForge licence, `.pypirc`, and Python configuration;
- Gemini, Aider, and VS Code configuration;
- GitHub CLI token state and the Imiron Google Cloud, Google Workspace CLI, and
  rclone state;
- `NFM.ttf` and `NotoSansJP-VariableFont_wght.ttf`;
- `~/Documents`, `~/Movies`, `~/Music`, `~/Public`, and `~/media`;
- Chrome profile data, because Firefox Sync is the chosen browser migration
  mechanism.

## Recommended order of work

1. **Complete:** the Home Manager repository was reviewed, committed, and pushed;
   its current commit matches `origin/main`. Doom and personal agents are also
   clean, pushed, and verified against their live remote refs.
2. **Complete:** `~/dev` has been fully reviewed; retained work was pushed and
   live-verified, and the remainder was explicitly dealt with or accepted as
   disposable.
3. **Complete:** `~/Desktop` and `~/Downloads` have been fully reviewed and
   dealt with, and every retained Google Drive folder reports fully synced.
4. **Complete:** retained Google Drive folders and representative restored files
   were verified, `~/Pictures` was preserved, and the restored Photos library
   opened successfully.
5. **Complete:** every item in
   [Remaining pre-return TODO](#remaining-pre-return-todo) is preserved and
   verified.
6. **Final sync complete:** Firefox completed **Sync now** on 2026-08-17. Verify
   the restored account when the replacement device becomes available.
7. **Complete, committed as `4d8d393`, and pushed:** the Brewfile and application
   reinstall list are recorded, and stable macOS/Maccy defaults plus manual
   iTerm2, input-source, Dock, protected permission, and font settings are
   captured.
8. **Deferred:** restore and test representative data and configuration when the
   replacement Mac becomes available.

## Completion criterion

Do not factory-reset the laptop until every applicable pre-return item below is
complete. Items explicitly deferred until the replacement Mac is available are
post-return verification and do not block erasing this laptop:

- [x] `~/dev` is fully reviewed and safe to erase; retained Git work was pushed
      and verified by remote inspection, and all other contents were dealt with.
- [x] `~/Desktop` and `~/Downloads` are fully reviewed and safe to erase.
- [x] Retained personal Git work outside `~/dev`, including `~/marvin`, is
      committed, pushed, and verified by a fresh clone or remote inspection.
- [x] Doom and personal agent configuration is committed, pushed, and verified
      against the live remote refs.
- [x] The Homebrew inventory, application reinstall list, and relevant macOS and
      application preferences are captured, committed as `4d8d393`, and pushed.
- [x] Home Manager configuration is committed and pushed.
- [x] Google Drive reports no pending work and every retained folder is fully
      synced.
- [x] Retained Google Drive folders are visible under **Computers**, and
      representative files have been restored successfully.
- [x] `~/Pictures` has been preserved, and all other local data, including
      `~/media`, is either already retained or explicitly disposable.
- [x] The Photos library opens from its restored copy.
- [x] Firefox has completed a final **Sync now**.
- [x] Python configuration, all API keys, the SpecForge licence, `.pypirc`,
      Gemini, Aider, VS Code, Imiron CLI state, and the two untracked fonts are
      explicitly disposable.
- [x] Stable Codex, Claude, Pi, and SSH configuration is preserved in personal
      Google Drive without authentication or generated state.
- [x] The zsh and bash histories are encrypted to the retained SSH key, and a
      full decryption plus checksum verification succeeded.
- [x] The passphrase-protected SSH key is preserved, its passphrase works, and
      its current configuration is included in the restore templates.

There are no unfinished pre-return preservation blockers. The following checks
are deferred and do not block erasure:

- [ ] The replacement device shows Firefox bookmarks, passwords, history,
      add-ons, and settings. This is deferred until the device is available.
- [ ] The replacement Mac can reproduce the shell, Git, Emacs, agent, and
      desktop environment from the preserved configuration. This is deferred
      until the replacement Mac is available.

Only after the applicable pre-return checks pass should accounts and licensed
applications be signed out and **Erase All Content and Settings** be used.
